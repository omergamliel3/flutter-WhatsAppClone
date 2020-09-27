# WhatsAppClone - _UNDER CONSTRUCTION_

A clean architecture WhatsApp clone Flutter project.

This app is a clone version of WhatsApp, built with Flutter. Real contacts replaced with DialogFlow API small-talk agents.

The main goal is to build readble, maintainable, testable, and high-quality flutter project using mvvm design pattern.

View layer (UI), viewmodel layer (business logic), and model layer (services, repos) are all seperated from each other. The view layer can only talks to the viewmodel. The model layer can only talks to the viewmodel layer. The viewmodel layer is the bridge between the layers, and can talks both view layer and model layer.

- Source files contains unit testing of each layer, and integration testing for verious app operations. 


## Screenshots

-------------------
-------------------
-------------------
-------------------

## Technologies
 
### Architecture
- **MVVM design pattern**

### Front-end
- **Flutter SDK**
- **Provider and Change Notifier for state management**

### Back-end
- **SQLite**
- **Firebase (Auth, Storage, Firestore, Functions)**
- **DialogFlow API (Google Cloud Platform)**

# Author 🙋

-   **Omer Gamliel** - [LinkedIn](https://www.linkedin.com/in/omer-gamliel-6a813a188/)
