using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace first_game
{
	public class GameControls
	{

		KeyboardState key_board = Keyboard.GetState();


		public Vector2 Movement(Vector2 position, int moving_speed) {

			Vector2 movement = Vector2.Zero;
			
		
			if (key_board.IsKeyDown(Keys.Right)) {

				movement.X += moving_speed;
				Console.WriteLine("Hi");
			}


			else if (key_board.IsKeyDown(Keys.Left)) {

				movement.X -= moving_speed;
			}


			if (key_board.IsKeyDown(Keys.Up)) {

				movement.Y -= moving_speed;
			}


			else if (key_board.IsKeyDown(Keys.Down)) {

				movement.Y += moving_speed;
			}

			position += movement;

			// Feed it back into the method so it saves where I previously was
			return position;

		}


		public Vector2 Shot(Vector2 position, Vector2 nano_position) {

		
	
			position = nano_position;
			return position;
		
		
		
		}



	}
}
