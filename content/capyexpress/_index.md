---
title: "capyexpress"
layout: plain
---

{{< rawhtml >}}
<div class="flex flex-wrap items-center justify-center">
<a class="pr3 link dim blue" href="#capyexpress">capyexpress</a>
<a class="pr3 link dim blue" href="#about">About</a>
<a class="pr3 link dim blue" href="#credits">Credits</a>
</div>
<hr class="bw1 b--black-20">
{{< /rawhtml >}}

{{< rawhtml >}}
<!-- Resizable div. -->
<style>
  .resizer { display:flex; margin:0; padding:0; resize:both; overflow:hidden; }
  .resizer > .resized { flex-grow:1; margin:0; padding:0; border:0; height:auto; }
</style>

<!-- Dependencies: d3, topojson, d3-geomap. -->
<link href="/third_party/d3-geomap/d3-geomap.css" rel="stylesheet">
<script src="/third_party/d3/d3.min.js"></script>
<script src="/third_party/topojson/topojson.min.js"></script>
<script src="/third_party/d3-geomap/d3-geomap.min.js"></script>
<!-- End dependencies. -->
{{< /rawhtml >}}

{{< rawhtml >}}
<div id="capyexpress"></div>
<div class="flex flex-wrap items-center justify-center">
  <div class="resizer bw1 ba w-60" id="wikiframe-container"><iframe class="resized" id="wikiframe"></iframe></div>
  <div class="bw1 ba w-40"><div class="d3-geomap" id="map"></div></div>
</div>

<div class="flex flex-wrap items-center justify-center">
  <div class="pr2"><p>Reading Wikipedia news for </p></div>
  <div class="pr3"><input class="dib" type="date" id="capydate"></div>
  <div><p><button onclick="UpdateCapyExpress()">Update</button></p></div>
</div>
{{< /rawhtml >}}

{{< rawhtml >}}
<!-- Script: d3-geomap. -->
<script>
  var map = d3.geomap()
    .geofile('/third_party/d3-geomap/topojson/world/countries.json')
    .draw(d3.select('#map')); 
</script>

<!-- Script: wikiframe sizing. -->
<script>
  let wfc = document.getElementById("wikiframe-container");
  wfc.style.height = "370px";
</script>

<!-- Script: Wikipedia current events portal. -->
<script>
  let MONTHS = [
    "January", "February", "March", "April",
    "May", "June", "July", "August",
    "September", "October", "November", "December"
  ];

  function DateFormatWiki(jsdate,sep) {
    return `${jsdate.getFullYear()}${sep}${MONTHS[jsdate.getMonth()]}${sep}${jsdate.getDate()}`;
  }

  function DateFormatInput(jsdate,sep) {
    return `${jsdate.getFullYear()}${sep}${(jsdate.getMonth() + 1).toString().padStart(2,"0")}${sep}${jsdate.getDate().toString().padStart(2,"0")}`;
  }

  async function GetWikiFrame(jsdate) {
    const datestring = DateFormatWiki(jsdate, "+");
    const url = `https://en.wikipedia.org/w/api.php?action=parse&format=json&origin=*&page=Portal%3ACurrent+events%2F${datestring}&prop=text&formatversion=2`;
    const query = await fetch(url, { method: "GET" }).catch (error => console.log(error));
    return await query.json();
  }

  async function ReplaceWikiFrame(jsdate) {
    const json = await GetWikiFrame(jsdate);
    const parsed = new DOMParser().parseFromString(json.parse.text, "text/html");
    const data = parsed.getElementById(DateFormatWiki(jsdate, "_"));
    let wf = document.getElementById("wikiframe");
    let wfdoc = document.getElementById("wikiframe").contentWindow.document;
    wfdoc.open();
    wfdoc.write(data.innerHTML);
    wfdoc.close();
    wfdoc.querySelectorAll("a").forEach(function (link) {
      var href = link.href;
      href = href.replace("wanshenl.me", "en.wikipedia.org").replace("localhost:1313", "en.wikipedia.org");
      link.setAttribute("href", href);
    });
  }

  async function UpdateCapyExpress() {
    let capydate = document.getElementById("capydate");
    let d = capydate.value.toString().split("-");
    ReplaceWikiFrame(new Date(d[0], parseInt(d[1]) - 1, d[2]));
  }

  (async function() {
    let today = new Date();
    let capydate = document.getElementById("capydate");
    capydate.value = DateFormatInput(today, "-");
    capydate.max = DateFormatInput(today, "-");
    UpdateCapyExpress();
  })();
</script>

<hr class="bw1 b--black-20">
{{< /rawhtml >}}

## About

A more pleasant way to keep up with changes in the world.

**FEATURES**

- The Wikipedia window is resizable.
- The map window is zoomable (click on country to zoom in, click on empty space to zoom out).
- Date picking.

**TODO**

- Parse current events text for automatic map highlighting of relevant countries.
- Make the map window resizable.
- Consider using Google Maps or OpenStreetMap more seriously. I like that d3-geomap doesn't need to call out to other web APIs though.
- Fix the sizing. The code in general is pretty grungy.

**DISCLAIMER**

I made this because I was tired of reading emotionally manipulative news. I used to read the Wikipedia current events portal to prepare for my high school's equivalent of the Cambridge General Paper, and back then I always thought that it would be great if events were overlaid on a world map. This isn't it (yet), but that's where I want to go.

If other people find this useful, great! But I'm not really dedicated to updating this beyond my own requirements. That is, emails and feature requests are welcome, but I might not reply in a timely fashion.

## Credits

Built with [Wikipedia's current events portal](https://en.wikipedia.org/wiki/Portal:Current_events) and [d3-geomap](https://d3-geomap.github.io/).
