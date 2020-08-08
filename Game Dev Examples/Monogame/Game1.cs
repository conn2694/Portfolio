using System;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace first_game
{
	/// <summary>
	/// This is the main type for your game.
	/// </summary>
	public class Game1 : Game
	{
		GraphicsDeviceManager graphics;
		SpriteBatch spriteBatch;

		Texture2D nano;
		Texture2D nichi_background;
		SpriteFont text_test;
		Vector2 nano_position;
		Texture2D bullet_test;
		Vector2 bullet_position;
		bool has_shot = false;
		int points;
		int moving_speed;


		public Game1()
		{
			graphics = new GraphicsDeviceManager(this);
			Content.RootDirectory = "Content";
		}

		/// <summary>
		/// Allows the game to perform any initialization it needs to before starting to run.
		/// This is where it can query for any required services and load any non-graphic
		/// related content.  Calling base.Initialize will enumerate through any components
		/// and initialize them as well.
		/// </summary>
		protected override void Initialize()
		{
			// TODO: Add your initialization logic here

			base.Initialize();
		}

		/// <summary>
		/// LoadContent will be called once per game and is the place to load
		/// all of your content.
		/// </summary>
		protected override void LoadContent()
		{
			// Create a new SpriteBatch, which can be used to draw textures.
			spriteBatch = new SpriteBatch(GraphicsDevice);

			// Where nano is innitionally
			nano_position = new Vector2(220, 550);


			//TODO: use this.Content to load your game content here 
			nano = Content.Load<Texture2D>("nano game");
			nichi_background = Content.Load<Texture2D>("42292_nichijou");
			text_test = Content.Load<SpriteFont>("text");
			bullet_test = Content.Load<Texture2D>("bullet");
		}

		/// <summary>
		/// Allows the game to run logic such as updating the world,
		/// checking for collisions, gathering input, and playing audio.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Update(GameTime gameTime)
		{
			// For Mobile devices, this logic will close the Game when the Back button is pressed
			// Exit() is obsolete on iOS
#if !__IOS__ && !__TVOS__
			if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
				Exit();
#endif

			Vector2 bullet_movement = Vector2.Zero;

			KeyboardState key_board = Keyboard.GetState();

			// Creates new object of my controls file
			GameControls movingControls = new GameControls();


			// Outputs method to the variable that will be used to draw the sprite
			nano_position = movingControls.Movement(nano_position, moving_speed);


			// Speed
			if (key_board.IsKeyDown(Keys.X))
			{

				moving_speed = 1;

			}

			else {

				moving_speed = 3;
			
			}

			// Keeps shot from coming back to nano if it's already shot
			if (has_shot == false) { 
				
				if (key_board.IsKeyDown(Keys.Z)) {
					points += 10;
					bullet_position = movingControls.Shot(bullet_position, nano_position);
					has_shot = true;


			}
			
			}
		



			if (has_shot == true)	{


				points += 10;

				bullet_position.Y -= 5;

				if (bullet_position.Y <= 0)	{

					has_shot = false;

				}
			}




			base.Update(gameTime);
		}


		protected override void Draw(GameTime gameTime)
		{
			graphics.GraphicsDevice.Clear(Color.CornflowerBlue);

			graphics.PreferredBackBufferWidth = 500;  
			graphics.PreferredBackBufferHeight = 700;
			graphics.ApplyChanges();


			spriteBatch.Begin();

				spriteBatch.Draw(nichi_background, Vector2.Zero);

				spriteBatch.Draw(nano, nano_position);


				if (has_shot == true) {
				spriteBatch.Draw(bullet_test, bullet_position, null, rotation: 4.7f);


				}
			spriteBatch.DrawString(text_test, "points: " + points, Vector2.Zero, Color.Aqua);
			           	

			spriteBatch.End();



			base.Draw(gameTime);
		}
	}
}
