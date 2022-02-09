

    
    // append the svg object to the body of the page
    var svg = d3.select("#my_dataviz")
      .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");
    
    //read data
    d3.csv(fileNameToLoad, function(data) {
    
      // Get the different categories and count them
      var n = categories.length
    
      // Compute the mean of each group
      allMaxes = []
      for (i in categories){
        currentGroup = categories[i]
        max = d3.max(data, function(d) { return +d[currentGroup] })
        allMaxes.push(max)
      }
    
      // Create a color scale using these means.
      var myColor = d3.scaleSequential()
        .domain([0.0,1.0])
        .interpolator(d3.interpolateViridis);
    
      var tickLocationX = height + margin.bottom / 4;
      // Add X axis
      var x = d3.scaleLinear()
        .domain([2005, 2025])
        .range([ 2005,2025 ]);
      var xAxis = svg.append("g")
        .attr("class", "xAxis")
        .attr("transform", "translate(0," + tickLocationX +")")
        .call(d3.axisBottom(x).tickValues([2005,2010,2015,2020]).tickSize(-height) )
    
      // Add X axis label:
      svg.append("text")
          .attr("text-anchor", "end")
          .attr("x", width/2 )
          .attr("y", height + 40)
          .text("Languages I've Used");
    
      // Create a Y scale for densities
      var y = d3.scaleLinear()
        .domain([0, n])
        .range([ height, 0]);
    
      // Create the Y axis for names
      var yName = d3.scaleBand()
        .domain(categories)
        .range([0, height])
        .paddingInner(1)
      svg.append("g")
        .call(d3.axisLeft(yName).tickSize(0))
        .select(".domain").remove()
    
      // Compute kernel density estimation for each column:
      //var kde = kernelDensityEstimator(kernelEpanechnikov(2), x.ticks(40)) // increase this 40 for more accurate density.
      var allDensity = []
      for (i = 0; i < n; i++) {
          key = categories[i]
            density = data.map(function(d){ 
               return  [parseInt(d["Date"]),parseFloat(d[key])]; 
              }) 
            allDensity.push({key: key, density: density})
          
      }
    
      // Add areas
      var myCurves = svg.selectAll("areas")
        .data(allDensity)
        .enter()
        .append("path")
          .attr("class", "myCurves")
          .attr("transform", function(d){
            return("translate(0," + (yName(d.key)-height) +")" )}
            )
          .attr("fill", function(d){
            grp = d.key ;
            index = categories.indexOf(grp)
            value = allMaxes[index]
            return myColor( value  )
          })
          .datum(function(d){return(d.density)})
          .attr("opacity", 0.7)
          .attr("stroke", "#000")
          .attr("stroke-width", 0.1)
          .attr("d",  d3.line()
              .curve(d3.curveBasis)
              .x(function(d) {
                 return x(0); 
                })
              .y(function(d) { return y(d[1]); })
          )
          .on('mouseover', function (d,i){
            //Dim all blobs
            d3.selectAll("path")
              .transition().duration(200)
              .style("fill-opacity", 0.1); 
            //Bring back the hovered over blob
            d3.select(this)
              .transition().duration(200)
              .style("fill-opacity", 1.0);	
          })
          .on('mouseout', function(){
            //Bring back all blobs
            d3.selectAll("path")
              .transition().duration(200)
              .style("fill-opacity", 1.0);
          });
    
      //Animate X axis apparition
       x.range([ 0, width ]);
      xAxis
        .transition()
        .duration(10)
        .call(d3.axisBottom(x).tickValues([2005,2010,2015,2020]).tickSize(-height).tickFormat(x => x.toString()) )
        .select(".domain").remove()
    
      // Animate densities apparition
      myCurves
        .transition()
        .duration(10)
        .attr("d",  d3.line()
            .curve(d3.curveBasis)
            .x(function(d) { return x(d[0]); })
            .y(function(d) { return y(d[1]); })
        )
    
    })

    //Note - there's a display bug if you mouseover while the transition is happening, so I just cut the transition time to 10 ms