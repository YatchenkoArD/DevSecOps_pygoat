import pytest
from django.urls import reverse

@pytest.mark.django_db
def test_homepage_status(client):
    """Простой дымовой тест главной страницы"""
    url = reverse('home')  # замени на реальный name из urls.py
    response = client.get(url)
    assert response.status_code == 200
