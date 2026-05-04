from rest_framework.routers import DefaultRouter
from .views import ViajeViewSet, unirse_lista_espera
from django.urls import path

router = DefaultRouter()
router.register(r'viajes', ViajeViewSet)

urlpatterns = router.urls + [
    path('viajes/<int:viaje_id>/lista-espera/', unirse_lista_espera, name='lista-espera'),
]
