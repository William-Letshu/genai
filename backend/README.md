## Backend server

### Database setup

- Make sure you're ./backend/db_data path created

- Turn on database
```bash
docker compose up -d
```

- Turn off database
```bash
docker compose down
```

### Starting up server
```bash
python manage.py runserver
```