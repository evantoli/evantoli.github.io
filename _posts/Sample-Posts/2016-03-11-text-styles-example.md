---
layout: post
title: Text formatting example
categories:
  - Sample-Posts
tags:
  - Text
  - Styles
  - Formatting
  - Intro
  - Jekyll
  - Tutorial
image:
---

This post presents the various text styles and how they present with this theme. 

<!--end-of-excerpt-->

<section id="table-of-contents" class="toc">
  <header>
    <h3>Overview</h3>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

## HTML Elements

Below is just about everything you'll need to style in the theme. 
Check the source code to see the many embedded elements within paragraphs.

# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6

### Body text

I want to show you what *some italics* looks like, but then thought
it would be remiss if I didn't also show **some bold** text. Of course you are
probably now wondering about **bold text _with italics_** or the converse of that
which would be *italic text __with bold__* text. 

Now that we have that covered that lets examine <u>some underlined</u> text
and also <strike>some struck-through</strike> text, both of which may be useful
presentation techniques to show additions and deletions.

<img class="img-half-width img-rounded pull-sm-right" 
    src="{{ '/images/crunchy-leaves-20151111-112903-1798.jpg' | prepend: site.baseurl | prepend: site.url }}" 
    alt="Crunchy leaves">
    

The image to the right has been pulled to the right on
small, medium and large devices using the
Bootstrap `pull-sm-right` CSS class. We have 
made it half-column width with a custom `img-half-width` CSS class
that will take affect on all but very small devices.

Water is H<sub>2</sub>O which freezes at 0°C and boils at 100°C.
You can calculate what these temperatures are in Fahrenheit with the
following formula:

<pre>
    °F = 9⁄5 × °C + 32
</pre>      


Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut
enim ad minim veniam, quis nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor
in reprehenderit in voluptate velit esse cillum dolore eu fugiat
nulla pariatur. Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.

*This is emphasized*. Donec faucibus. Nunc iaculis suscipit 
dui. 53 = 125. Water is H2O. Nam sit amet sem. Aliquam libero 
nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl. 
The New York Times (That’s a citation). Underline.
Maecenas ornare tortor. Donec sed tellus eget sapien 
fringilla nonummy. Mauris a ante. Suspendisse quam sem, 
consequat at, commodo vitae, feugiat in, nunc. Morbi 
imperdiet augue quis tellus.

HTML and CSS are our tools. Mauris a ante. Suspendisse quam sem, consequat at, commodo vitae, feugiat in, nunc. Morbi imperdiet augue quis tellus. Praesent mattis, massa quis luctus fermentum, turpis mi volutpat justo, eu volutpat enim diam eget metus.

### Blockquotes

> Lorem ipsum dolor sit amet, test link adipiscing elit. Nullam dignissim convallis est. Quisque aliquam.

## List Types

### Ordered Lists

1. Item one
   1. sub item one
   2. sub item two
   3. sub item three
2. Item two

### Unordered Lists

* Item one
* Item two
* Item three

## Tables

| Header1 | Header2 | Header3 |
|:--------|:-------:|--------:|
| cell1   | cell2   | cell3   |
| cell4   | cell5   | cell6   |
|----
| cell1   | cell2   | cell3   |
| cell4   | cell5   | cell6   |
|=====
| Foot1   | Foot2   | Foot3
{: rules="groups"}

## Code Snippets

{% highlight css %}
#container {
  float: left;
  margin: 0 -240px 0 0;
  width: 100%;
}
{% endhighlight %}

## Buttons

Make any link standout more when applying the `.btn` class.

{% highlight html %}
<a href="#" class="btn btn-success">Success Button</a>
{% endhighlight %}

<div markdown="0"><a href="#" class="btn">Primary Button</a></div>
<div markdown="0"><a href="#" class="btn btn-success">Success Button</a></div>
<div markdown="0"><a href="#" class="btn btn-warning">Warning Button</a></div>
<div markdown="0"><a href="#" class="btn btn-danger">Danger Button</a></div>
<div markdown="0"><a href="#" class="btn btn-info">Info Button</a></div>

## Notices

**Watch out!** You can also add notices by appending `{: .notice}` to a paragraph.
{: .notice}

