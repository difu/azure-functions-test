import azure.functions as func
import logging

app = func.FunctionApp()

@app.blob_trigger(arg_name="myblob", path="uploadedblobs/{name}",
                               connection="AzureWebJobsStorage")
def BlobTrigger1(myblob: func.InputStream):
    logging.info(f"Difu Python blob trigger function processed blob "
                f"Name: {myblob.name} "
                f"Blob Size: {myblob.length} bytes")