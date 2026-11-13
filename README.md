# Practica 9 - Automatizacion de servidores Ubuntu con Ansible y Docker

## Descripcion

Laboratorio de automatizacion con Ansible sobre cinco servidores Ubuntu creados con Docker. El playbook actualiza el cache de APT, crea el usuario `itla`, crea la carpeta `/home/itla/app`, crea el archivo `hola.txt` e instala `cowsay` y `htop` en los cinco servidores.

## Tecnologias utilizadas

- Docker y Docker Compose
- Ubuntu 22.04 (contenedores)
- OpenSSH Server
- Ansible Core 2.20.1
- WSL con Ubuntu

## Estructura del proyecto

```text
ansible-practice/
├── Dockerfile
├── docker-compose.yml
├── inventory.ini
├── ansible.cfg
├── playbook.yml
├── setup-ssh-keys.sh
├── verificar.sh
├── resultado-playbook.txt
├── resultado-verificacion.txt
└── README.md
```

## 1. Crear y levantar los cinco servidores

Desde la carpeta del proyecto:

```bash
docker compose up -d --build
docker compose ps
```

El `docker-compose.yml` publica los puertos SSH `2201` a `2205`, uno por cada servidor.

## 2. Instalar Ansible en WSL

```bash
wsl --install
sudo apt update
sudo apt install -y ansible
ansible --version
```

## 3. Autenticacion SSH

El `Dockerfile` crea el usuario `ansible` con contrasena `ansible` y permisos `sudo` sin contrasena. El archivo `inventory.ini` contiene el usuario, la contrasena y el puerto de cada servidor.

En este entorno no estaba instalado `sshpass`, por lo que se agrego `setup-ssh-keys.sh` para copiar una clave SSH publica a los cinco contenedores y permitir la conexion con Ansible:

```bash
chmod +x setup-ssh-keys.sh
./setup-ssh-keys.sh
```

Tambien se puede usar la autenticacion por contrasena instalando `sshpass`:

```bash
sudo apt install -y sshpass
```

## 4. Ejecutar el playbook

Importante: ejecutar Ansible desde una ruta nativa de WSL, por ejemplo `~/ansible-practice`, para que se aplique `ansible.cfg` y no aparezca la advertencia de directorio world-writable.

```bash
ansible webservers -m ping
ansible-playbook playbook.yml
```

## 5. Verificar el resultado

```bash
./verificar.sh
```

La verificacion comprueba en cada servidor:

- El usuario `itla` existe.
- Existe `/home/itla/app/hola.txt`.
- `cowsay` esta instalado y funciona.
- `htop` esta instalado.

## Resultado de la ejecucion

La ejecucion final del playbook termino sin errores y de forma idempotente en los cinco servidores:

```text
PLAY RECAP *********************************************************************
ubuntu1                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu2                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu3                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu4                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu5                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

La salida completa esta en [resultado-playbook.txt](resultado-playbook.txt).

La verificacion de los cinco servidores esta en [resultado-verificacion.txt](resultado-verificacion.txt).

## Repositorio

https://github.com/LeydiD23/ansible-practice
