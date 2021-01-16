using Genie.Router
using LandscapingController
using ContactController
using AboutController
using HomeController

route("/", HomeController.homePage)
route("/landscaping", LandscapingController.landscapingPage)
route("/about", AboutController.aboutPage)
route("/contact", ContactController.contact, method=POST, named=:contact_request)
