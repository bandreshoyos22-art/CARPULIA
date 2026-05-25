from rest_framework.routers import DefaultRouter

from .views import (
    ViajeViewSet,
    VehiculoViewSet,
    RatingViewSet,
    PerfilViewSet
)

router = DefaultRouter()

router.register(
    r'viajes',
    ViajeViewSet
)

router.register(
    r'vehiculos',
    VehiculoViewSet
)

router.register(
    r'ratings',
    RatingViewSet
)

router.register(
    r'perfiles',
    PerfilViewSet
)

urlpatterns = router.urls