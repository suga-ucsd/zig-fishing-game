const std = @import("std");
const rl = @import("raylib");

const GameScreen = enum {
    LOGO,
    TITLE,
    GAMEPLAY,
    ENDING
};




fn cameraInteraction(cameraMode: *rl.CameraMode, camera: *rl.Camera) void{
    const KEY_ONE_PRESSED = rl.isKeyPressed(rl.KeyboardKey.key_one);
    const KEY_TWO_PRESSED = rl.isKeyPressed(rl.KeyboardKey.key_two);
    const KEY_THREE_PRESSED =rl.isKeyPressed(rl.KeyboardKey.key_three);
    const KEY_FOUR_PRESSED = rl.isKeyPressed(rl.KeyboardKey.key_four);
    const KEY_P_PRESSED = rl.isKeyPressed(rl.KeyboardKey.key_p);

    if (KEY_ONE_PRESSED) {
        cameraMode.* = rl.CameraMode.camera_free;
        camera.up = rl.Vector3.init(0.0, 1.0, 0.0);
    } if (KEY_TWO_PRESSED) {

        cameraMode.* = rl.CameraMode.camera_first_person;
        camera.up = rl.Vector3.init(0.0, 1.0, 0.0);

    } if (KEY_THREE_PRESSED) {

        cameraMode.* = rl.CameraMode.camera_third_person;
        camera.up = rl.Vector3.init(0.0, 1.0, 0.0);
    } if (KEY_FOUR_PRESSED) {

        cameraMode.* = rl.CameraMode.camera_orbital;
        camera.up = rl.Vector3.init(0.0, 1.0, 0.0);
    } if(KEY_P_PRESSED) {
        if (camera.projection == rl.CameraProjection.camera_perspective) {
            cameraMode.* = rl.CameraMode.camera_third_person;
            camera.position = rl.Vector3.init(0.0, 2.0, -100.0);
            camera.target = rl.Vector3.init(0.0, 2.0, 0.0);
            camera.up = rl.Vector3.init(0.0, 1.0, 0.0);
            camera.fovy = -20.0;
            camera.projection = rl.CameraProjection.camera_orthographic;

        } else if(camera.projection == rl.CameraProjection.camera_orthographic) {
            cameraMode.* = rl.CameraMode.camera_third_person;
            camera.position = rl.Vector3.init(0.0, 2.0, -10.0);
            camera.target = rl.Vector3.init(0.0, 2.0, 0.0);
            camera.up = rl.Vector3.init(0.0, 1.0, 0.0);
            camera.fovy = 60.0;
            camera.projection = rl.CameraProjection.camera_perspective;
        }
    }

}



pub fn main() !void {

    const WIDTH: i32 = 640;
    const HEIGHT: i32 = 480;

    std.debug.print("lmaoo\n",.{});
    rl.initWindow(WIDTH, HEIGHT, "Fish fish away!!!!");

    var currentScreen: GameScreen = .LOGO;
    var framesCounter: u32 = 0;

    rl.setTargetFPS(120);
    rl.disableCursor();
    defer rl.closeWindow();



    var camera = rl.Camera {
        .position = rl.Vector3.init(0.0, 2.0, 4.0),
        .target = rl.Vector3.init(0.0, 2.0, 0.0),
        .up = rl.Vector3.init(0.0, 1.0, 0.0),
        .fovy = 60.0,
        .projection = rl.CameraProjection.camera_perspective,
    };


    var cameraMode: rl.CameraMode = rl.CameraMode.camera_first_person;


    while(!rl.windowShouldClose()) {

        const keyPressed = rl.isKeyPressed(rl.KeyboardKey.key_enter);
        const gestDetect = rl.isGestureDetected(rl.Gesture.gesture_tap);

        cameraInteraction(&cameraMode, &camera);
        rl.Camera.update(&camera, cameraMode);

        switch (currentScreen) {
                .LOGO => {
                    framesCounter += 1;
                    if (framesCounter > 120) {
                        currentScreen = .TITLE;
                    }
                },
            .TITLE => currentScreen = if (keyPressed or gestDetect) .GAMEPLAY else .TITLE,
            .GAMEPLAY => currentScreen = if (keyPressed or gestDetect) .ENDING else .GAMEPLAY,
            .ENDING => currentScreen = if (keyPressed or gestDetect) .TITLE else .ENDING,

            }


        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        switch (currentScreen) {
            .LOGO => {
                rl.drawText("LOGO SCREEN", 20, 20, 40, rl.Color.white);
                rl.drawText("WAIT FOR 2 SECS...", 290, 220, 20, rl.Color.green);

            },
            .TITLE => {
                rl.drawRectangle(0, 0, WIDTH, HEIGHT, rl.Color.green);
                rl.drawText("TITLE SCREEN", 20, 20, 40, rl.Color.dark_green);
                rl.drawText("PRESS ENTER OR TAP TO JUMP TO GAMEPLAY", 120, 220, 20, rl.Color.dark_green);
            },
            .GAMEPLAY => {
                rl.clearBackground(rl.Color.ray_white);

                rl.beginMode3D(camera);
                defer rl.endMode3D();

                rl.drawPlane(rl.Vector3.init(0.0, 0.0, 0.0), rl.Vector2.init(32.0, 32.0), rl.Color.light_gray);
                rl.drawCube(rl.Vector3.init(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, rl.Color.blue);
                rl.drawCube(rl.Vector3.init(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, rl.Color.lime);
                rl.drawCube(rl.Vector3.init(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, rl.Color.gold);



            },
            .ENDING => {
                rl.drawRectangle(0, 0, WIDTH, HEIGHT, rl.Color.blue);
                rl.drawText("ENDING SCREEN", 20, 20, 40, rl.Color.dark_blue);
                rl.drawText("PRESS ENTER OR TAP TO JUMP TO TITLE", 120, 220, 20, rl.Color.dark_blue);
            },
            // else => break,
        }

    }
}
