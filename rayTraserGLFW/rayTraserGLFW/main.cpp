#include <iostream>
#include "display.h"
#include "mesh.h"
#include "debugTimer.h"
#include "inputManager.h"
#include "sceneParser.h"

using namespace glm;

int main(int argc,char** argv)
{
	scene scn = scene("res/scene.txt");
	Display display(1000,1000,"hello!");
	Shader shader("res/shaders/basicShader");
	Vertex vertices[] = {Vertex(vec3(-1,-1,0),vec2(0,0),vec3(0,0,1)),Vertex(vec3(1,-1,0),vec2(0,0),vec3(0,0,1)),Vertex(vec3(1,1,0),vec2(0,0),vec3(0,0,1)),Vertex(vec3(-1,1,0),vec2(0,0),vec3(0,0,1))};
	unsigned int indices[] = {0,1,2,0,2,3};
	Mesh mesh(vertices,4,indices,6);
	const char *ctr = (char *)glGetString(GL_VERSION);
	glfwSetKeyCallback(display.m_window,key_callback);

	while(!glfwWindowShouldClose(display.m_window))
	{

		display.Clear(0.0f, 0.0f, 0.0f, 1.0f);
		scn.loadtoShader(shader);
		shader.Bind();
		shader.Update();
	
		mesh.Draw();

		display.SwapBuffers();

		glfwPollEvents();
	}
	//getchar();
	return 0;
}