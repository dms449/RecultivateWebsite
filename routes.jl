using Genie.Router
using Genie.Requests

using LandscapingController
using LawncareController
using ContactFormController
using ScheduleVisitFormController
using AboutController
using HomeController


route("/", HomeController.homePage, named=:home_page)
route("/landscaping", LandscapingController.landscapingPage, named=:landscaping_page)
route("/lawncare", LawncareController.lawncarePage, named=:lawncare_page)
route("/about", AboutController.aboutPage, named=:about_page)
route("/contact", ContactFormController.contactSubmit, method=POST, named=:contact_request)
route("/schedule", ScheduleVisitFormController.scheduleVisitForm)
route("/schedule", ScheduleVisitFormController.scheduleVisitSubmit, method=POST, named=:schedule_visit)


