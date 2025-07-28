# SAP-Based Inventory & Training Chatbot System

This project was developed during my internship at **BMC Otomotiv San. ve Tic. A.Ş.** in Summer 2025. It is a modular SAP-based inventory and internal training management system integrated with a generative AI chatbot for natural language queries.

##  Technologies Used

- **SAP ABAP (OOP)** – for backend business logic and database operations  
- **SAP ERP (SE11/SE80/SE38/ALV)** – for UI development and data modeling  
- **NestJS (TypeScript)** – for REST API exposing SAP data  
- **Next.js (React)** – for frontend chatbot interface  
- **OpenAI API (RAG)** – for natural language understanding and dynamic response generation  

## Features

### SAP Inventory & Training System

- **Normalized Inventory Tracking (3NF)** with users, materials, warehouses, and stock entries  
- **Instructor Portal:** course assignments, student registrations, grading  
- **Editable ALV Interfaces** with dropdown inputs, real-time validations, and mail notifications  
- **Dynamic ID management** and input assistance via `CL_GUI_ALV_GRID` events  

### AI Chatbot with SAP Integration
 **Demo Video:** [Watch on YouTube](https://www.youtube.com/watch?v=83WA9xf7GlY)
- Users can ask natural questions like:  
  - _"How many Vuran antennas are in İzmir warehouse?"_  
  - _"Who registered Kirpi armor last week?"_  
- Backend extracts intent and slots → queries SAP DB → summarizes via OpenAI  
- Supports Turkish queries and domain-specific vocabulary  
