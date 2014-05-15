---
layout: default
title: Tags

---

<h1>{{ page.title }}</h1>

{% for tag in site.tags %}
{{ tag[0] }}<br>
{{ tag[1] }}<br>
{% endfor %}

