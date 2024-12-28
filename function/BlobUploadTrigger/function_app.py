import azure.functions as func
import logging

app = func.FunctionApp()

@app.blob_trigger(arg_name="myblob", path="userblobs/{name}",
                               connection="AzureWebJobsStorage")
def BlobTrigger1(myblob: func.InputStream):
    """
    This function is an Azure Blob Storage trigger designed to process blob
    events. The function logs details such as the name and size of the blob
    being processed. The input blob is accessed via the `myblob` parameter,
    which supports operations such as reading the blob's contents or
    accessing its metadata. The function is triggered whenever a blob is
    created or updated in the specified Azure storage container.

    :param myblob: Input stream representing the triggered blob. Allows
        access to blob content and metadata.
    :type myblob: func.InputStream
    """
    logging.info(f"Difu Python blob trigger function processed blob "
                f"Name: {myblob.name} "
                f"Blob Size: {myblob.length} bytes")