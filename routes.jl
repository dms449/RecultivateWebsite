using Genie.Router
using Genie.Requests

using LandscapingController
using LawncareController
using ContactFormController
using PortfolioController
using ScheduleVisitFormController
using AboutController
using HomeController

Genie.Sessions.init()


route("/", HomeController.homePage, named=:home_page)
route("/landscaping", LandscapingController.landscapingPage, named=:landscaping_page)
route("/landscaping/portfolio", PortfolioController.portfolioPage, named=:portfolio_page)
route("/lawncare", LawncareController.lawncarePage, named=:lawncare_page)
route("/about", AboutController.aboutPage, named=:about_page)
route("/contact", ContactFormController.contactSubmit, method=POST, named=:contact_submit)
route("/schedule", ScheduleVisitFormController.scheduleVisitForm, named=:schedule_visit_page)
route("/schedule", ScheduleVisitFormController.scheduleVisitSubmit, method=POST, named=:schedule_visit_submit)


