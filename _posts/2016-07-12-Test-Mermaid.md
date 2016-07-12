---
layout: post
title: 测试mermaid
tags: [测试]
---

本文用来进行测试。


<div class="mermaid" id="i141">
        graph LR
        A[AWS Kinesis] --&gt; B[Spark Streaming Application]
        B --&gt; C[AWS S3]
        B --&gt; D[AWS Redshift]
        C -.-&gt; D
</div>