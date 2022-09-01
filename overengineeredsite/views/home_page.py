from django.http import HttpResponse
from django.shortcuts import render

class home_page(object) : 
    @staticmethod
    def view(request):
        return render(request, 'home_page.html', {})
