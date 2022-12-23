<?php
namespace samdark\hydrator;

/**
 * Hydrator can be used for two purposes:
 *
 * - To extract data from a class to be futher stored in a persistent storage.
 * - To instantiate a class having its data.
 *
 * In both cases it is saving and filling protected and private properties without calling
 * any methods which leads to ability to persist state of an object with properly incapsulated
 * data.
 */
class Hydrator
{
    /**
     * Mapping of keys in data array to property names.
     * @var array
     */
    private $map;

    /**
     * Local cache of reflection class instances
     * @var array
     */
    private $reflectionClassMap = [];

    public function __construct(array $map)
    {
        $this->map = $map;
    }

    /**
     * Creates an instance of a class filled with data according to map
     *
     * @param array $data
     * @param string $className
     * @return object
     *
     * @since 1.0.2
     */
    public function hydrate($data, $className)
    {
        $reflection = $this->getReflectionClass($className);
        $object = $reflection->newInstanceWithoutConstructor();

        foreach ($this->map as $dataKey => $propertyName) {
            if (!$reflection->hasProperty($propertyName)) {
                throw new \InvalidArgumentException("There's no $propertyName property in $className.");
            }

            if (isset($data[$dataKey])) {
                $property = $reflection->getProperty($propertyName);
                $property->setAccessible(true);
                $property->setValue($object, $data[$dataKey]);
            }
        }

        return $object;
    }

    /**
     * Fills an object passed with data according to map
     *
     * @param array $data
     * @param object $object
     * @return object
     *
     * @since 1.0.2
     */
    public function hydrateInto($data, $object)
    {
        $className = get_class($object);
        $reflection = $this->getReflectionClass($className);

        foreach ($this->map as $dataKey => $propertyName) {
            if (!$reflection->hasProperty($propertyName)) {
                throw new \InvalidArgumentException("There's no $propertyName property in $className.");
            }

            if (isset($data[$dataKey])) {
                $property = $reflection->getProperty($propertyName);
                $property->setAccessible(true);
                $property->setValue($object, $data[$dataKey]);
            }
        }

        return $object;
    }

    /**
     * Extracts data from an object according to map
     *
     * @param object $object
     * @return array
     */
    public function extract($object)
    {
        $data = [];

        $className = get_class($object);
        $reflection = $this->getReflectionClass($className);

        foreach ($this->map as $dataKey => $propertyName) {
            if ($reflection->hasProperty($propertyName)) {
                $property = $reflection->getProperty($propertyName);
                $property->setAccessible(true);
                $data[$dataKey] = $property->getValue($object);
            }
        }

        return $data;
    }

    /**
     * Returns instance of reflection class for class name passed
     *
     * @param string $className
     * @return \ReflectionClass
     * @throws \ReflectionException
     */
    protected function getReflectionClass($className)
    {
        if (!isset($this->reflectionClassMap[$className])) {
            $this->reflectionClassMap[$className] = new \ReflectionClass($className);
        }
        return $this->reflectionClassMap[$className];
    }
}
