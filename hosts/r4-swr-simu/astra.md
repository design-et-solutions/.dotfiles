> https://astra-fr-preprod.uas.topsky.thalesdigital.io/

Voici les nouveaux acces sur Preprod France : Astra Web App

Voici les credentials pour l’approver :
cedif-approver-01@yopmail.com
N1@Y$nPuiDdlhn75L&rU

Et pour le pilote :
pierre-adrien.plessix@yopmail.com
SoftwareR25\*

---

POST
https://api.astra-fr-preprod.uas.topsky.thalesdigital.io/api/v5/auth/login

body:
{
password: "N1@Y$nPuiDdlhn75L&rU",
username: "cedif-approver-01@yopmail.com"
}

GET
https://yopmail.com/en/mail?b=cedif-approver-01&id=me_ZwHjAGR2ZGZ0BGR3ZQNjAwt0ZmH1Zt==

expect

Two Factor Authentication

Team UTM <astraportal@astrautm.com>

Friday, May 16, 2025 3:49:17 PM

Dear CEDIF Approver-01,

Your Two Factor activation key is 779712 to authenticate your account.

Best regards,
UTM Support.

POST
https://api.astra-fr-preprod.uas.topsky.thalesdigital.io/api/v5/auth/login

body:
{
otp: "779712"
password: "N1@Y$nPuiDdlhn75L&rU",
username: "cedif-approver-01@yopmail.com"
}

---

Request

```sh
http POST https://api.astra-fr-preprod.uas.topsky.thalesdigital.io/api/v4/auth/login \
username="cedif-approver-01@yopmail.com" \
password="N1@Y$nPuiDdlhn75L&rU"
```

Response

```sh
{
    "data": {
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIyIiwic3ViIjoiY2VkaWYtYXBwcm92ZXItMDFAeW9wbWFpbC5jb2
        "accountId": 0,
        "activationKey": "**Not Disclosed**",
        "authKey": null,
        "businessName": null,
        "companyAddress": null,
        "companyEmail": null,
        "companyTelephone": null,
        "dashboard": null,
        "dateOfBirth": "0001-01-01T00:00:00",
        "emailId": "ced**************@yopmail.com",
        "emiratesID": null,
        "expire_in": null,
        "firstName": null,
        "idExpiryDate": null,
        "isAcivated": false,
        "isBlocked": false,
        "lastName": null,
        "logoURL": null,
        "mobileNo": null,
        "operatorType": null,
        "passportExpiryDate": null,
        "photoUrl": null,
        "roleTypeID": null,
        "rpasPermitNo": null,
        "tradeLicenceCopyUrl": null,
        "userId": 0,
        "userName": null,
        "userProfile": null
    },
    "error": false,
    "errorMessages": null,
    "pageInfo": null,
    "pageSize": 0,
    "startIndex": 0,
    "totalRecords": 1,
    "units": {
        "altitude": {
            "label": "ft",
            "value": "Feet"
        },
        "clouds": {
            "label": "%",
            "value": "Percentage"
        },
        "currency": {
            "label": "EUR",
            "value": "EUR"
        },
        "distance": {
            "label": "m",
            "value": "Meter"
        },
        "gust": {
            "label": "m/s",
            "value": "Meter/Second"
        },
        "humidity": {
            "label": "%",
            "value": "Percentage"
        },
        "pressure": {
            "label": "hPa",
            "value": "Hectopascal"
        },
        "speed": {
            "label": "m/s",
            "value": "Meter/Second"
        },
        "temperature": {
            "label": "c",
            "value": "Celsius"
        },
        "time": {
            "label": "gst",
            "value": "Local"
        },
        "visibility": {
            "label": "m",
            "value": "Meter"
        },
        "weight": {
            "label": "kg",
            "value": "Kilogram"
        },
        "wind_Direction": {
            "label": "°",
            "value": "Degree"
        },
        "wind_Speed": {
            "label": "m/s",
            "value": "Meter/Second"
        }
    }
}
```

Request

```sh
http POST https://api.astra-fr-preprod.uas.topsky.thalesdigital.io/api/v4/auth/verifyuserotp \
otp="779712" \
username="cedif-approver-01@yopmail.com" \
password="N1@Y$nPuiDdlhn75L&rU"
```
