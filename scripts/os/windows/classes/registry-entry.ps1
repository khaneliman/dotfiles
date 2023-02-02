class RegistryEntry {
	[string]$Key
	[string]$Type
	[string]$Value
    [string]$Path

	RegistryEntry([string]$key, [string]$type, [string]$value, [string]$path) {
		$this.Key = $key
		$this.Type = $type
		$this.Value = $value
		$this.Path = $path
	}
}