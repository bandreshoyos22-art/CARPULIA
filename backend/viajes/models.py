from django.db import models
from django.contrib.auth.models import User


class Vehiculo(models.Model):

    conductor = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    marca = models.CharField(
        max_length=50
    )

    modelo = models.CharField(
        max_length=50
    )

    color = models.CharField(
        max_length=30
    )

    placa = models.CharField(
        max_length=10
    )

    cupos = models.IntegerField()



class Viaje(models.Model):

    conductor = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    vehiculo = models.ForeignKey(
        Vehiculo,
        on_delete=models.CASCADE
    )

    origen = models.CharField(
        max_length=100
    )

    destino = models.CharField(
        max_length=100
    )

    fecha = models.DateField()

    hora_salida = models.TimeField()

    cupos_disponibles = models.IntegerField()

    precio = models.DecimalField(
        max_digits=10,
        decimal_places=2
    )



class Rating(models.Model):

    driver = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='ratings_recibidos'
    )

    passenger = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='ratings_realizados'
    )

    viaje = models.ForeignKey(
        Viaje,
        on_delete=models.CASCADE
    )

    score = models.IntegerField()

    comment = models.TextField(
        blank=True
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    def __str__(self):

        return f"{self.driver.username} - {self.score}"



# NUEVO PERFIL PARA REGISTRO

class Perfil(models.Model):

    usuario = models.OneToOneField(
        User,
        on_delete=models.CASCADE
    )

    universidad = models.CharField(
        max_length=100
    )

    carrera = models.CharField(
        max_length=100
    )

    direccion_residencia = models.CharField(
        max_length=200
    )

    def __str__(self):

        return self.usuario.username