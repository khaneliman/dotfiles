Create file called "authorized_keys" in this directory and paste into it the contents of a public key from a keypair

To do this, you must have created a public and private key-pair.  Use the following steps to do this:

From command line (telnet / putty)

1. Type "ssh-keygen -t rsa -f /boot/config/plugins/ssh/<USERNAME>/.ssh/id_rsa"
   NB.  replace "<USERNAME>" with the name of the user.
   
2. When prompted, type a passphrase if you wish for additional security for the private key.  Press enter if not for no passphrase

3. Create a copy the public key into the same location and call it "authorized_keys".
   eg.  cp /boot/config/plugins/ssh/<USERNAME>/.ssh/id_rsa.pub /boot/config/plugins/ssh/<USERNAME>/.ssh/authorized_keys
   
Verify everything has been created correctly.

Upon restarting SSH, the plug-in will look for (and find) authorized_keys and copy this file to the users home directory.  eg.  /home/someuser/.ssh/authorized_keys

----------------------------------------------------------

The private part of the key is "id_rsa".  You must take this to the system you intend to connect *from*.  If you intend to use Putty to connect, then you *MUST* first convert the private key from standard OpenSSH format to Putty compatible format.

A copy of PUTTYGEN for UnRAID has been included.  To convert the private key, follow these steps:

From command line (telnet / putty):

1. Type "/usr/bin/puttygen /boot/config/plugins/ssh/<USERNAME>/.ssh/id_rsa -o /boot/config/plugins/ssh/<USERNAME>/.ssh/id_rsa.ppk
2. In Putty, create an entry to your UnRAID server and in "Connection -> SSH -> Auth" section of Putty, browse for the file you created (id_rsa.ppk).

Verify you are able to login successfully with the private key.