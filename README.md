**Auroracoin**

https://github.com/validierungcc/auroracoin-docker

https://auroracoin.is/


Example docker-compose.yml

     ---
    version: '3.9'
    services:
        auroracoin:
            container_name: auroracoin
            image: vfvalidierung/auroracoin
            restart: unless-stopped
            user: 1000:1000
            ports:
                - '12340:12340'
                - '127.0.0.1:12341:12341'
            volumes:
                - 'auroracoin:/aurora/.auroracoin'
    volumes:
       auroracoin:

**RPC Access**

    curl --user '<user>:<password>' --data-binary '{"jsonrpc":"1.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:12341
