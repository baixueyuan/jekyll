---
layout: post
title: 测试mermaid
tags: [测试]
---

{% stylesheet mermaid %} 本文用来进行测试。


{% mermaid %}
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
{% endmermaid %}