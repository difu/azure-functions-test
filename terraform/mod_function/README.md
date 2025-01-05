# Azure Function App Terraform Module Documentation

This Terraform module is designed to provision and configure a **Python-based Azure Function App** using an 
App Service Plan with a **Linux OS** runtime. The module facilitates automated deployment and management of
cloud functions, suitable for hosting serverless applications on Azure.

---

## **Purpose**
This module automates the creation of an Azure Function App environment, making it faster and simpler to deploy 
serverless applications. It includes provisions for infrastructure components, environment variables for 
runtime configuration, system-assigned identity for secure resource access, and deployment of packaged function code.

---

## **Features**
1. **Function App Creation**:
   - Provisions an Azure Function App configured to run Python (version 3.9) using the **Linux OS**.
   - Automatically assigns a globally unique name by combining the provided `function_name` with a randomly generated integer to prevent name conflicts.

2. **App Service Plan**:
   - Configures a consumption-based **App Service Plan** with the SKU "Y1", optimized for serverless workloads.

3. **Azure Storage Integration**:
   - Configures the function to read its code package directly from an Azure Blob Storage container.
   - Uses variables to define details of the storage account (e.g., account name, access key, container) for dynamic configuration.

4. **Application Insights Integration**:
   - Facilitates monitoring and telemetry by linking the Function App with Azure's **Application Insights** via the provided `instrumentation_key`.

5. **Code Packaging and Deployment**:
   - Implements a **local build process** that packages the function code (`zip`) and uploads it to the configured Azure Storage Blob for the Function App to use.
   - Automatically tracks changes in the source function code using a checksum for reliable updates.

6. **System-Assigned Identity for Secure Access**:
   - Configures the Function App with a **managed (system-assigned) identity**, which can be used for secure interactions with other Azure services.

---

## **Inputs**
The module supports configurable variables to make it reusable in different environments. Some key inputs include:

- **Function Application Details**:
  - `function_name` - Specifies the base name of the Function App.
  - `functions_path` - Specifies the local path to the directory containing function source code.

- **Resource Group**:
  - `resource_group` - Accepts details of the resource group where the resources will be deployed (e.g., `name`, `location`, `id`).

- **Storage Account Configuration**:
  - `storage_account` - Expects details (e.g., `name`, `id`, `primary_access_key`) of the Azure Storage Account hosting the code package.
  - `storage_container_name` - Specifies the name of the storage container for uploading the function's ZIP file.

- **Instrumentation Key**:
  - `instrumentation_key` - Specifies the Application Insights instrumentation key for enabling monitoring.

---

## **Outputs**
The module provides useful outputs for integrating with other modules or resources:

- `principal_id`: The **managed identity's principal ID** for the Function App, which can be used to configure role-based access control (RBAC) for secure access to resources.
- `unique_function_app_name`: The **name of the created Function App**, which can be used for further references.

---

## **Module Workflow**
1. **Random Integer Generation**:
   - A random integer is generated to ensure the Function App's name is unique globally.

2. **Azure Resource Deployment**:
   - Creates a Function App along with its dependencies such as the App Service Plan, Blob Storage for function packages, and System-Assigned Identity.

3. **Code Deployment**:
   - Function source code is packaged into a ZIP file and uploaded to an Azure Blob Storage.
   - The Function App is configured to fetch and execute the code directly from the storage location.

4. **Environment Setup**:
   - Sets up runtime environment variables such as `FUNCTIONS_WORKER_RUNTIME`, `AzureWebJobsStorage`, and App Insights instrumentation key.

---


## **Pre-Requisites**
- An existing Azure Resource Group.
- An Azure Storage Account for hosting the function code package.
- Application Insights resource for monitoring (optional but recommended).

---
