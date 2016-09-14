/**
 * Created by Fabian on 13.09.2015.
 */
package com.company.PhoenixRealmClient.appengine {
import _4X_.Task;

import _U_5._bo;

import _zo._8C_;
import _zo._mS_;

import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.events.TimerEvent;
import flash.utils.Timer;

public class InitAppEngineTask extends Task {

    private static const RETRY_TIME:int = 1000;

    [Inject]
    public var appEngine:AppEngine;
    [Inject]
    public var loadingText:_bo;

    public var onComplete:Function;

    private var retryTimer:Timer;
    private var webRequest:_0B_u;

    override protected function startTask():void {
        this.webRequest = new _0B_u(Parameters._fK_(), "/app", false);
        this.webRequest.addEventListener(_mS_.TEXT_ERROR, this.onError);
        this.webRequest.addEventListener(_8C_.GENERIC_DATA, this.onSuccess);
        this.sendRequest();
    }

    private function sendRequest():void {
        this.webRequest.sendRequest("/init", {});
    }

    private function restartTimer():void {
        this.retryTimer = new Timer(RETRY_TIME, 1);
        this.retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
        this.retryTimer.start();
    }

    private function stopRetryTimer():void {
        this.retryTimer.stop();
        this.retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
        this.retryTimer = null;
    }

    private function onError(_arg1:_mS_):void {
        this.loadingText.dispatch('<p align="center">Error loading AppEngine, server offline?</p>');
        this.restartTimer();
    }

    private function onTimerComplete(_arg1:TimerEvent):void {
        this.sendRequest();
    }

    private function onSuccess(_arg1:_8C_):void {
        this.appEngine.parameters = XML(_arg1.data_);
        _C_t(true);
        this.onComplete();
        if (this.retryTimer != null) {
            this.stopRetryTimer();
        }
    }

    public function isInitialized():Boolean {
        return this.appEngine.parameters != null;
    }
}
}
