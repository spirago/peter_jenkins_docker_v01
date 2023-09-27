FROM alpine:3.13.5
COPY . /app
RUN make /app
CMD python /app/app.py
