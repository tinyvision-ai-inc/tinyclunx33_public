#include <zephyr/drivers/video.h>
#include <zephyr/drivers/video-controls.h>
#include <zephyr/usb/class/usbd_uvc.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(app_main, LOG_LEVEL_INF);

static const struct device *const uvc0_dev = DEVICE_DT_GET(DT_NODELABEL(uvc0));
static const struct device *const uvcmanager0_dev = DEVICE_DT_GET(DT_NODELABEL(uvcmanager0));
K_THREAD_STACK_DEFINE(thread0_stack, 1024);
struct k_thread thread0_data;

static const struct device *const uvc1_dev = DEVICE_DT_GET(DT_NODELABEL(uvc1));
static const struct device *const uvcmanager1_dev = DEVICE_DT_GET(DT_NODELABEL(uvcmanager1));
K_THREAD_STACK_DEFINE(thread1_stack, 1024);
struct k_thread thread1_data;

#define APP_THREAD_PRIORITY 5

int app_usb_init(void);

static void app_thread_main(void *p0, void *p1, void *p2)
{
	const struct device *uvc_dev = p0;
	const struct device *video_dev = p1;
	struct video_format fmt = {0};
	int ret;

	/* Get the video format once it is selected by the host */
	while (true) {
		ret = video_get_format(uvc_dev, &fmt);
		if (ret == 0) {
			break;
		}
		if (ret != -EAGAIN) {
			LOG_ERR("Failed to get the video format");
			return;
		}

		k_sleep(K_MSEC(10));
	}

	ret = video_stream_start(video_dev, VIDEO_BUF_TYPE_OUTPUT);
	if (ret != 0) {
		LOG_ERR("Failed to start %s", video_dev->name);
		return;
	}

	LOG_INF("Done, exiting and letting the USB stack run");
}

int main(const struct device *uvc_dev, const struct device *uvcmanager_dev)
{
	int ret;

	uvc_set_video_dev(uvc0_dev, uvcmanager0_dev);
	uvc_set_video_dev(uvc1_dev, uvcmanager1_dev);

	ret = app_usb_init();
	if (ret != 0) {
		LOG_ERR("Failed to initialize USB");
		return ret;
	}

	k_thread_create(&thread0_data, thread0_stack, K_THREAD_STACK_SIZEOF(thread0_stack),
                        app_thread_main, (void *)uvc0_dev, (void *)uvcmanager0_dev, NULL,
			APP_THREAD_PRIORITY, 0, K_NO_WAIT);

	k_thread_create(&thread1_data, thread1_stack, K_THREAD_STACK_SIZEOF(thread1_stack),
                        app_thread_main, (void *)uvc1_dev, (void *)uvcmanager1_dev, NULL,
			APP_THREAD_PRIORITY, 0, K_NO_WAIT);

	return 0;
}
