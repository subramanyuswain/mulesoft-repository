# oneway-ssl-demo
This is a demo project representing the one way SSL in mulesoft

Below are the command used to generate the Self signed certificates used in the code

1.	Generate the server keystore using java keytool(JDK/bin folder) : 

	keytool -genkey -alias mule-server -keyalg RSA -keystore E:\mule-training\SSL\server-keystore.jks

2.	Keystore is a combination of public key and pricate key - Extract the public key from server keystore using below command : 

	keytool -export -alias mule-server -keystore E:\mule-training\SSL\server-keystore.jks -file E:\mule-training\SSL\server-truststore.crt

3.	Import the client truststore from public key of server-keystore(server-truststore) using below command : 

	keytool -import -alias mule-server -keystore E:\mule-training\SSL\client-truststore.jks -file E:\mule-training\SSL\server-truststore.crt
