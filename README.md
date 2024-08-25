# Docker Compose Files Repository

Welcome to the Docker Compose Repository! This repository contains all the Docker Compose files needed to spin up various Docker-based environments easily.

---

## 📂 Repository Structure

- **[project1/](./project1)**
  - `docker-compose.yml` - Docker Compose for Project 1.
- **[project2/](./project2)**
  - `docker-compose.yml` - Docker Compose for Project 2.
- **[docker-backups/](./docker-backups/)** (Generated automatically)
  - This directory is where backup files are stored.
- **[backup-script.sh](./backup-script.sh)**
  - A script to backup your Docker Compose files and volumes.

> **Note:** Each subdirectory under the root of this repository corresponds to a different Docker project, with its own Docker Compose file.

---

## 🚀 Usage

### Prerequisites

Make sure you have `docker`, `docker-compose` (or `docker compose`), and `bash` installed.

### How to Deploy a Project

1. Navigate to the desired Docker project directory:
   
   ```bash
   cd project1
   ```

2. Start the Docker containers:

   ```bash
   docker compose up -d
   ```

3. To stop the services, run:

   ```bash
   docker compose down
   ```

### How to Backup a Docker Project

1. Run the `backup-script.sh` with the corresponding project directory name:

   ```bash
   ./backup-script.sh project1
   ```

2. This will create a compressed backup of the project, including its volumes, in the `docker-backups/` directory.

---

## 📜 License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 💡 Contributing

Feel free to submit issues and/or pull requests if you have ideas on how to improve the setup or if you notice any bugs.

---

## 🔗 Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

Happy Dockerizing! 🐳