#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/usb/class/usbd_uvc.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(app_main, LOG_LEVEL_INF);

static const struct device *const uvc0_dev = DEVICE_DT_GET(DT_NODELABEL(uvc0));
static const struct device *const uvcmanager0_dev = DEVICE_DT_GET(DT_NODELABEL(uvcmanager0));

int app_usb_init(void);

int main(void)
{
	struct video_format fmt = {.type = VIDEO_BUF_TYPE_OUTPUT};
	int ret;

	uvc_set_video_dev(uvc0_dev, uvcmanager0_dev);

	ret = app_usb_init();
	if (ret != 0) {
		LOG_ERR("Failed to initialize USB");
		return ret;
	}

	/* Get the video format once it is selected by the host */
	while (true) {
		ret = video_get_format(uvc0_dev, &fmt);
		if (ret == 0) {
			break;
		}
		if (ret != -EAGAIN) {
			LOG_ERR("Failed to get the video format");
			return ret;
		}

		k_sleep(K_MSEC(10));
	}

	ret = video_stream_start(uvcmanager0_dev, VIDEO_BUF_TYPE_OUTPUT);
	if (ret != 0) {
		LOG_ERR("Failed to start %s", uvcmanager0_dev->name);
		return ret;
	}

	LOG_INF("Done, exiting main() and letting the USB stack run");

	return 0;
}
