from django.db import models
from django.contrib.auth.models import User

class Vehiculo(models.Model):
    conductor = models.ForeignKey(User, on_delete=models.CASCADE)
    marca = models.CharField(max_length=50)
    modelo = models.CharField(max_length=50)
    color = models.CharField(max_length=30)
    placa = models.CharField(max_length=10)
    cupos = models.IntegerField()

class Viaje(models.Model):
    conductor = models.ForeignKey(User, on_delete=models.CASCADE)
    vehiculo = models.ForeignKey(Vehiculo, on_delete=models.CASCADE)
    origen = models.CharField(max_length=100)
    destino = models.CharField(max_length=100)
    fecha = models.DateField()
    hora_salida = models.TimeField()
    cupos_disponibles = models.IntegerField()
    precio = models.DecimalField(max_digits=10, decimal_places=2)