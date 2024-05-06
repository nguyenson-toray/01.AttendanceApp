import pyzkfp

def read_fingerprint():
    """Reads a fingerprint from a ZKFP2 scanner.

    Returns:
        A tuple containing the captured fingerprint template data (if successful)
        and None (if capture failed).

    Raises:
        Exception: If an error occurs during initialization or capture.
    """

    zk = pyzkfp.ZKFP2()

    try:
        # Initialize ZKFP2 object
        zk.Init()
        device_count = zk.GetDeviceCount()
        if device_count > 0:
            zk.OpenDevice(0)  # Open the first device found
            print("Scanner connection successful!")
        else:
            print("No scanner found.")

        # Capture fingerprint
        while True:
            try:
                capture_result = zk.AcquireFingerprint()
                if capture_result:
                    print("Fingerprint captured successfully!")
                    return capture_result[0]  # Return template data
                else:
                    print("Fingerprint capture failed. Please retry.")
            except Exception as e:
                print("Error during capture:", e)

    finally:
        # Close scanner connection
        zk.CloseDevice()
        print("Scanner connection closed.")

if __name__ == "__main__":
    template_data = read_fingerprint()
    if template_data:
        print("Fingerprint template data:", template_data)
    else:
        print("Fingerprint capture failed.")
