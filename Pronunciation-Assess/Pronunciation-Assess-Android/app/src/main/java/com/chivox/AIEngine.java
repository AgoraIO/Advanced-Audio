package com.chivox;

public final class AIEngine {

    static {
        System.loadLibrary("aiengine");
    }

    /**
     * 引擎回调接口
     */
    public interface aiengine_callback {
    	/**
    	 * 抽象函数，调用时需重写函数实体
    	 * @param id 返回id
    	 * @param type 返回类型
    	 * @param data 返回数据
    	 * @param size 数据大小
    	 * @return 返回值
    	 */
        public abstract int run(byte[] id, int type, byte[] data, int size);
    }

	/** 回调返回消息类型 - json */
	public static int AIENGINE_MESSAGE_TYPE_JSON = 1;
	/** 回调返回消息类型 - bin */
    public static int AIENGINE_MESSAGE_TYPE_BIN = 2;

    public static int AIENGINE_OPT_GET_VERSION = 1;
    public static int AIENGINE_OPT_GET_MODULES = 2;
    public static int AIENGINE_OPT_GET_TRAFFIC = 3;
    public static int AIENGINE_OPT_SET_WIFI_STATUS = 4;
    public static int AIENGINE_OPT_GET_PROVISION = 5;
    public static int AIENGINE_OPT_GET_SERIAL_NUMBER = 6;
    
    
    /**
     * 创建引擎
     * @param cfg 配置信息
     * @param androidContext Context对象
     * @return 0：失败
     *    引擎对象值：成功
     */
	
    public static native long aiengine_new(String cfg, Object androidContext);
    /**
     * 移除引擎
     * @param engine 引擎对象值
     * @return 返回值
     */
    public static native int aiengine_delete(long engine);
	
	/**
     * 启动引擎
     * @param engine 引擎对象值
     * @param param 参数配置字符串
     * @param id 存储引擎生成的id字符
     * @param callback aiengine_callback对象
	 * @param context Context对象
     * @return 返回值
     */
	public static native int aiengine_start(long engine, String param, byte[] id, aiengine_callback callback, Object context);
   
    /**
     * 向引擎缓冲区填入语音数据
     * @param engine 引擎对象值
     * @param data 数据
     * @param size 数据大小
     * @return 返回值
     */
    public static native int aiengine_feed(long engine, byte[] data, int size);
	
	/**
     * 停止引擎
     * @param engine 引擎对象值
     * @return 返回值
     */
    public static native int aiengine_stop(long engine);

	/**
     * 评分重试 
     * @param engine 引擎对象值
     * @param id 存储引擎生成的id字符
     * @param callback aiengine_callback对象
	 * @param context Context对象
     * @return 返回值
     */
	public static native int aiengine_redo(long engine, byte[] id, aiengine_callback callback, Object context);
	
    /**
     * 取消引擎, 用于出现异常情况下，用户可以取消引擎
     * @param engine 引擎对象值
     * @return 返回值
     */
    public static native int aiengine_cancel(long engine);
    public static native int aiengine_log(long engine, String log);
    public static native int aiengine_opt(long engine, int opt, byte[] data, int size);
	
	/**
     * 获取设备ID
     * @param device_id 存储id的缓冲byte[]空间
     * @param androidContext Context对象
     * @return 返回值
     */
    public static native int aiengine_get_device_id(byte[] device_id, Object androidContext);
}
