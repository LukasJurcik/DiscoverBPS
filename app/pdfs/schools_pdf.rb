class SchoolsPdf < Prawn::Document
  def initialize(schools, grade_levels, grade_level, geocoded_address, view, session)
    super(top_margin: 40)
    @schools = schools.sort
    @grade_levels = grade_levels
    @grade_level = grade_level
    @geocoded_address = geocoded_address
    @view = view
    @session = session
    
    title
    schools_table
    created_at
  end
  
  def title
    formatted_text([{ :text => "Eligible Schools ", :size => 24, :style => :bold },
            { :text => " (#{@geocoded_address.street_address}, #{@geocoded_address.city}, #{@geocoded_address.state} / Grade #{@session[:grade_level]})", :size => 15}])
  end

  def schools_table
    move_down 20
    table school_rows do
      row(0).font_style = :bold
      self.column_widths = [135, 110, 100, 65, 120]
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def school_rows
    [["Name", "Eligibility", "Transportation", "Distance", "2011 Hours"]] +
    @schools.map do |school|
      [school.name, school.eligibility, transportation_eligibility(school), distance_in_miles_from_meters(school.distance), school.grade(@session[:grade_level]).try(:hours)]
    end
  end

  def transportation_eligibility(school)
    if school.eligibility =~ /Walk Zone/
      "Walk Zone"
    elsif @grade_level.name == "High"
      "MBTA"
    else
      "School Bus"
    end
  end
  
  def eligibility_title(school)
    "#{@view.eligibility_title(school)}"
  end
  
  def distance_in_miles_from_meters(distance)
    "#{@view.distance_in_miles_from_meters(distance)} mi"
  end
  
  def created_at
    move_down 20
    text "#{Date.today}"
  end
end