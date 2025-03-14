%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo([
  {
    "exceptionPayload": null,
    "payload": {
      "Employee": [
        {
          "first_name": "Melba",
          "last_name": "Roy Mouton",
          "department": "Computers",
          "job_title": "Assistant Chief of Research Programs",
          "start_date": "01/01/2021",
          "employee_type": "mathematician"
        },
        {
          "first_name": "Annie",
          "last_name": "Easley",
          "department": "Software Development",
          "job_title": "Technical Lead",
          "start_date": "06/02/2020",
          "employee_type": "Rocket Scientist"
        },
        {
          "first_name": "Jack",
          "last_name": "Dawson",
          "department": "Ship Development",
          "job_title": "Manageing Lead",
          "start_date": "06/02/2020",
          "employee_type": "Bucket Scientist"
        },
        {
          "first_name": "Kate",
          "last_name": "Winslet",
          "department": "Hot Lady",
          "job_title": "Photography",
          "start_date": "06/02/2020",
          "employee_type": "Socket Scientist"
        }
      ]
    },
    "attributes": null
  }
])