
module Vis_SOM

  def visualize(labels)
    cell_wdt=max_str_width(labels)
    cell_hgt=max_population_in_node
    ncells=node_rows[0].size
    node_rows.each do |row|
      nrow=Array.new(cell_hgt).collect { []}
      row.each do |cell|
        emp_arr=Array.new(cell_hgt,cell_content(cell_wdt))
        siz=cell.bucket.size
        k=(cell_hgt-siz)/2
        emp_arr[k,siz]=cell.bucket.map {|m| labels[m].center(cell_wdt)}
        emp_arr.each_index {|i|  nrow[i] << emp_arr[i]}
      end
      puts hor_dots(cell_wdt,ncells)
      nrow.each {|r| puts "|#{r.join("|")}|" }
    end
      puts hor_dots(cell_wdt,ncells)
  end

  def hor_dots(cell_wdt,ncells)
    "".center(cell_wdt*ncells+(ncells-1)+2,"-")
  end
  def cell_content(width)
    "".center(width)
  end

private
  def max_str_width(labels)
    labels.map {|lb| lb.size}.max
  end

  def max_population_in_node
    nodes.map { |nd| nd.bucket.size }.max
  end
end
