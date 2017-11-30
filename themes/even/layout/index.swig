{% extends "_layout.swig" %}
{% import '_macro/post.swig' as post_template %}

{% block title %} {{ config.title }} {% endblock %}

{% block content %}
  <section id="posts" class="posts">
    {% for post in page.posts %}
      {% if post.visible !== 'hide'%}
        {{ post_template.render(post) }}
      {% endif %}
    {% endfor %}
  </section>

  {% include "_partial/pagination.swig" %}
{% endblock %}
