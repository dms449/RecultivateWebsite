using Genie.Router
using LandscapingController
using LawncareController
using ContactController
using AboutController
using HomeController

route("/", HomeController.homePage)
route("/landscaping", LandscapingController.landscapingPage)
route("/lawncare", LawncareController.lawncarePage)
route("/lawncare", LawncareController.calculateEstimate, method=POST, named=:calculate_estimate)
route("/about", AboutController.aboutPage)
route("/contact", ContactController.contact, method=POST, named=:contact_request)
