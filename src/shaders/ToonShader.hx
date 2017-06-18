package shaders;

class ToonShader extends hxsl.Shader {
    static var SRC = {
        @:import h3d.shader.BaseMesh;

        function selectColor (c : Float) : Float {
            var res = 0.0;
            if (c > 0.9) {
                res = 1.0;
            } else if (c > 0.7) {
                res = 0.9;
            } else if (c > 0.5) {
                res = 0.5;
            }            
            else {
                res = 0.1;
            }
            return res;
        }

        function calcColor() : Vec3 {            
            var r = selectColor (pixelColor.rgb.r);
            var g = selectColor (pixelColor.rgb.g);
            var b = selectColor (pixelColor.rgb.b);

            return vec3(r, g, b);

        }

        function fragment() {            
			pixelColor.rgb = calcColor();
        }
    }
}