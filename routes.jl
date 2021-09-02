using Genie.Router
using Genie.Requests
using GenieAuthentication

using LandscapingController
using LawncareController
using ContactFormController
using PortfolioController
using ScheduleVisitFormController
using AboutController
using HomeController
using DashboardController
using LawncarePropertiesController
using LawncareEventsController
using PropertiesController
using PersonsController

# using Genie.Renderer.Html: html



Genie.Sessions.init()


route("/", HomeController.homePage, named=:home_page)
route("/landscaping", LandscapingController.landscapingPage, named=:landscaping_page)
route("/landscaping/portfolio", PortfolioController.portfolioPage, named=:portfolio_page)
route("/lawncare", LawncareController.lawncarePage, named=:lawncare_page)
route("/about", AboutController.aboutPage, named=:about_page)
route("/contact", ContactFormController.contactSubmit, method=POST, named=:contact_submit)
route("/schedule", ScheduleVisitFormController.scheduleVisitForm, named=:schedule_visit_page)
route("/schedule", ScheduleVisitFormController.scheduleVisitSubmit, method=POST, named=:schedule_visit_submit)


# route("/dashboard", named=:contractor_dashboard) do; @authenticated!
#   DashboardController.dashboard()
# end
route("/dashboard", DashboardController.dashboard, named=:dashboard) 

# LAWNCARE PROPERTIES
route("/lawncare-properties", LawncarePropertiesController.index, named=:lawncare_properties_index) 
route("/lawncare-properties/:id::Int/edit", LawncarePropertiesController.edit, named=:edit_lawncare_property) 
route("/lawncare-properties/:id::Int/update", LawncarePropertiesController.update, method=POST, named=:update_lawncare_property) 
route("/lawncare-properties/new", LawncarePropertiesController.new, named=:new_lawncare_property) 
route("/lawncare-properties/create", LawncarePropertiesController.create, method=POST, named=:create_lawncare_property) 

# LAWNCARE EVENTS
route("/lawncare-events/create", LawncareEventsController.create, method=POST, named=:create_lawncare_event)

# PROPERTIES
route("/properties", PropertiesController.index, named=:properties_index) 
route("/properties/:id::Int/edit", PropertiesController.edit, named=:edit_property) 
route("/properties/:id::Int/update", PropertiesController.update, method=POST, named=:update_property) 
route("/properties/new", PropertiesController.new, named=:new_property) 
route("/properties/create", PropertiesController.create, method=POST, named=:create_property) 

# PERSONS
route("/persons", PersonsController.index, named=:persons_index) 
route("/persons/:id::Int/edit", PersonsController.edit, named=:edit_person) 
route("/persons/:id::Int/update", PersonsController.update,method=POST, named=:update_person) 
route("/persons/new", PersonsController.new, named=:new_person) 
route("/persons/create", PersonsController.create, method=POST, named=:create_person) 
# route("/lawncare-events", LawncareEventsController.index, named=:lawncare_events_page)
# route("/lawncare-events", LawncareEventsController.index, named=:lawncare_events_page)

# route("/person/new", Person)

# route("/login") do; 
#   html("<h1> hi contractor </h1>")
#   # h1("Welcome Admin") |> html
# end

# function index()
#   authenticated() || throw(ExceptionalResponse(redirect(:show_login)))

#   h1("Welcome Admin") |> html
# end
