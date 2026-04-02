As you explore, you will find direct GitHub links to the source code for most of these projects. Each repository includes a README in both English and German. Feel free to use, modify or even share these resources. All I ask is that you keep them free and don't sell them. A huge thank you to my partners listed at the bottom of the page for their support. Enjoy the portfolio! ♡

# CONTENTS:

<br/><br/>

### 1. 2016 – 2019 | Unity Engine: Early Explorations & Prototyping
- Foundational projects and initial experiments in game development.

### 2. 2019 – 2021 | Modding Frameworks: Grand Theft Auto V
- Development of custom systems and multiplayer frameworks.

### 3. 2022 – 2024 | Unity Engine: School & Independent Projects
- Advanced school assignments and specialized technical explorations.

### 4. 2025 – Present | Current Works: Systems & Immersion
- Ongoing focus on complex mechanics and immersive environments.

<br/><br/>

## 2016 – 2019 | Unity Engine: Early Explorations & Prototyping
#### Tech Stack: Unity Engine, C# & Blender.

<br/><br/>

### Overview:
While my journey into game development began in 2014, it was in 2016 that I transitioned into the Unity Engine to bring my concepts to life. During this period, I developed an independent horror project, which served as a foundation for mastering C# scripting, simple enemy AI systems and interactive environment design.
The following previews showcase my early work and reflect the beginning of my passion for the creative freedom found in game development, turning complex ideas into playable experiences.

<br/><br/>

### Simple AI & Pathfinding: 

- Implemented simple enemy AI utilizing Unity’s NavMesh system and custom waypoint scripting to create dynamic patrol and chase behaviors.

<video width="640" height="360" controls>
  <source src="assets/videos/Enemy_waypoints.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

<video width="640" height="360" controls>
  <source src="assets/videos/Navmesh_preview.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

##### [Source Code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/unity/simpleai)

### Procedural VFX (Particle Systems):

- I also worked on a dynamic blood-splatter effect. By utilizing collision detection within the Particle System, I ensured that every impact resulted in a unique visual output, avoiding repetitive "canned" animations.

<video width="640" height="360" controls>
  <source src="assets/videos/Blood_particle.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

- Another scripted example using some assets.

<iframe width="560" height="315" src="https://www.youtube.com/embed/7seLKmyWc58?si=K120UIK6M6zz_6_e" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

![BILD](/assets/pictures/Gore.png)

### First-Person Animation: 

- I crafted a variety of animations, with a heavy focus on first-person movements. My goal was to move away from robotic motions and create a feel that’s fluid and immersive for the player.

<video width="640" height="360" controls>
  <source src="assets/videos/Reload.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

### Immersive Gameplay Mechanics (Player States): 

- I implemented a "Shock System" where entering specific trigger zones changes the player’s physical state (heavy breathing audio and increased camera/aim sway), enhancing psychological horror through mechanical feedback.
<iframe width="560" height="315" src="https://www.youtube.com/embed/D7W4wC5KI78?si=8_Omy2p7tQU7ztnp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

![BILD](/assets/pictures/Scene.png)

### Technical Optimization (Graphics Menu): 

- Performance optimization is very important, which is why I also worked on a comprehensive settings menu allowing users to toggle graphic settings like Anti-aliasing, Texture quality, Shadow resolution, Shadow distance, Resolution, V-Sync, Anisotropic Filtering and more. This ensured scalability across both high-end and low-end hardware.

![BILD](/assets/pictures/Graphics_setting.png)
##### [Source Code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/unity/mainmenu)

### Cross-Platform Input Support:

- I built a flexible input system with full support for Xbox and DualShock controllers. My goal was to make sure playing on a PC feels just as smooth and responsive as playing on a console.

![BILD](/assets/pictures/Gamepad.png)
##### [Source Code SOON]()

<br/><br/>

### Note:

Beyond these highlights, I have built dozens of smaller projects to sharpen my skills. While I was constantly iterating on playable builds for my horror title, the milestones below represent my biggest technical leaps and the core of my growth as a developer.

<br/><br/>
<br/><br/>

## 2019 – 2021 | Modding Frameworks: Grand Theft Auto V (FiveM)

#### Tech Stack: Lua, basic SQL, 3ds Max, ZModeler, Blender & OpenIV.

<br/><br/>

### Overview:

End of 2019 I started building complex, large-scale systems for my community. I dedicated over 1,500 hours to developing immersive gameplay mechanics and managing persistent worlds for a live player base.

![BILD](/assets/pictures/LSPD.png)

#### My key Contributions:

- Systems programming: Developed core gameplay features using Lua to enhance player immersion and interaction.
- Database management: Designed and maintained a robust SQL infrastructure to handle player data, inventory systems and dynamic housing.
- World building: Utilized CodeWalker and OpenIV to modify yMap files for game environments.
- Custom assets: Brought unique visuals to the game by creating and optimizing 3D models in Blender and ZModeler.

### Realistic Inventory & Weapon Restriction:

- The problem: The "infinite pocket" system in the vanilla game broke immersion and created unfair combat advantages.
- The solution: Developed a custom Lua script to limit player loadouts to a realistic configuration (e.g. two sidearms and one primary long weapon).
- Impact: Forced strategic gameplay by requiring players to use vehicle trunks or armories/bags to switch heavy gear. Notably, this mechanic was later revealed as a core feature for the upcoming Grand Theft Auto VI.
<iframe width="560" height="315" src="https://www.youtube.com/embed/kvhgb0Rjm2Q?si=RTPUdai43mQmfDJB" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/modding/script_waffensystem)

### Emergency lighting system Overhaul:

- The goal: I wanted to give Roleplay enthusiasts a much more immersive, high-fidelity experience with emergency vehicles.
- How it works: I moved away from the basic "on/off" vanilla toggle and built a multi-state system. This gives players manual control over specific siren tones, patterns and flash speeds.
The result: It completely changed how emergency ops feel. While the custom GUI was still in the development, the depth of the siren system added a huge layer of realism.

<iframe width="560" height="315" src="https://www.youtube.com/embed/KwA9SP9If0I?si=xLbumc2ITB9jDBD0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/modding/script_lichtsystem)

### Dynamic fire/flame System:

- The impact: This project really took off, hitting over 50.000 views and reaching way beyond my usual community.
- The tech: I built a randomized event system that triggers fires at specific coordinates, keeping the gameplay unpredictable and fresh.
- The innovation: When this dropped, it was one of the first systems of its kind, helping shift the standard for how job-based scripts work in FiveM.
<iframe width="560" height="315" src="https://www.youtube.com/embed/GuhfZzz1I4o?si=KHKWWXQQJaYcqhFD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
![BILD](/assets/pictures/Hose.png)

##### [Source code fire/flames](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/modding/script_feuer)

### Mask Shop System:

Community Choice: Implemented the most-requested feature, allowing players to customize appearances and hide their identities.
Bug Fixing: Solved critical desync and invincibility issues by developing a custom "Menu State" for smoother interactions.
Stability: Optimized code to manage player health and movement flags, ensuring the game remains stable during character customization.

- Challenge and Community: Implementing the most requested feature to allow players to customize appearances and hide their identities caused severe desync and invincibility bugs.
- Technical fix: Resolved complex state machine issues by implementing a "Menu State."
- Code Quality: Managed player health and movement flags (frozen states) to ensure stability during character customization. (Refer to client.lua lines 150-166 in my repository for implementation details).
<iframe width="560" height="315" src="https://www.youtube.com/embed/MJYCk7PjWg0?si=pXETnlpDfg8l3yJM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/modding/script_masken)

### Immersive Armory & Animation Syncing:

- Philosophy: Moving away from "press button to receive item" prompts in favor of tactile, visual interactions.
- Technical Execution: Spent extensive time syncing character animations with precise world coordinates for weapon props.
- Outcome: A highly polished, physical armory system that reinforces player immersion through visual feedback and realistic timing.
<iframe width="560" height="315" src="https://www.youtube.com/embed/6d4M4rus-UE?si=_2jo7eIRxtx-JhyS" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/modding/script_polizeilager)

<br/><br/>

### Other projects & world building:

![BILD](/assets/pictures/WIP.png)

- Beyond my main systems, I love giving back to the modding scene. I have released several free scripts and mapping projects to help other server owners level up their realism. For me, it’s always been about blending technical polish with solid environmental storytelling.

<br/><br/>

### Custom Mapping & Level Design:

- LSIA border checkpoint: I built a detailed border crossing near the airport to create more immersive roleplay opportunities. To help other server owners, I released the full source files on public forums for anyone to use.
<iframe width="560" height="315" src="https://www.youtube.com/embed/MY1Vn3XYUdE?si=tmkhnlPU1iY4vayK" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

#### [LSIA Border Map public site](https://forum.cfx.re/t/release-ymap-fivem-lsia-border-map-with-detailed-objects-interiors-dynamic-objects/1570768)

- Cayo Perico infrastructure: To fix a major gameplay oversight in the original Rockstar update, I built and integrated a fully functional gas station on the island. I didn't just place a pump. I added a detailed shop section, custom props and ambient NPC scenarios to make the whole area feel like a natural part of the map.

![BILD](/assets/pictures/Forum_Cayo_Perico.png)

#### [Gas Pump Detailed YMap site](https://forum.cfx.re/t/release-cayo-perico-gas-pump-detailed-ymap-with-a-little-shop-dynamic-objects/1906934)

- I focus on small-scale environmental polish to bridge the gap between a static map and a living world. By refining those tiny interactions, I make sure every corner of a scene feels like it has a purpose.

![BILD](/assets/pictures/Forum_Border.png)

#### [Sandy Shores Sheriff Exterior Map site](https://forum.cfx.re/t/sandy-shores-sheriff-exterior-map/1874666)

![BILD](/assets/pictures/Forum_Legion_Square.png)

#### [Legion Square Hotdog stand site](https://forum.cfx.re/t/release-map-fivem-legion-square-hotdog-burger-stand-outdoor-objects-upgrade/1468741)

- Check out more of my unlisted projects [HERE](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/modding)!

<br/><br/>

### Note:

These highlights are just a small selection of the systems and environments I have developed over the past few years. If you are interested in a deeper technical breakdown or would like to see more of my work in action, feel free to visit my forum, check out my showcases on YouTube or contact me directly. I’m always open to discussing technical solutions and new projects.

<br/><br/>
<br/><br/>

## 2022 – 2024 | Unity Engine: School & Independent Projects 

### Tech Stack: Unity Engine, Blender, Autodesk Maya & C#.

<br/><br/>

### Overview:

One of my most significant milestones was the development and presentation of a comprehensive game concept under my label *Colorless Studios.*
I approached this project with a professional mindset, pushing the boundaries of my existing skillset and strategically utilizing diverse assets to streamline the development process. This project served as a definitive test of my ability to manage a complex workflow under a deadline.
During this period, I integrated Unity’s HDRP (High Definition Render Pipeline) into my workflow to enhance both visual fidelity and performance. While this specific technology has since been deprecated in Unity 6.5 and higher, it represented a significant leap in my ability to deliver high-end, advanced graphics and optimized rendering at the time.

- Take a moment to explore the visual concept and demo highlights below:

<iframe width="560" height="315" src="https://www.youtube.com/embed/8ZXlZ9BjeFs?si=E9G5BWgcRMUjwGpt" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

![BILD](/assets/pictures/Horse_preview.png)

- To validate the project, I distributed the playable demo to an international group of testers for comprehensive feedback. Below, you can see their feedbacks and insights, which were instrumental in refining the concept and evaluating the gameplay experience from a global perspective:

<iframe width="560" height="315" src="https://www.youtube.com/embed/rxMbD1j6Wq4?si=dhbv4CtgpaOGfr4k" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### Extra Additions:

- In addition to the core project, I developed a concept for vehicle wheel deformation. Although this feature was not integrated into the final demo for the showcase, it represents a significant technical milestone in my exploration of physics-based mechanics. You can view the technical demonstration in the video below:

<iframe width="560" height="315" src="https://www.youtube.com/embed/SycE8ZyFlnA?si=PEhuYCbG2I11AEeO" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

![BILD](/assets/pictures/Deformation.png)
![BILD](/assets/pictures/Deformation2.png)

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/unity/deformation)

- I took the basic demo mechanics and leveled up the tree-chopping system. I linked it to a proper inventory and added advanced particle effects, including environment-aware collisions. This was a direct evolution of the dynamic blood splatter logic I built for my previous horror project in 2019.

<iframe width="560" height="315" src="https://www.youtube.com/embed/pdudZyNDIB8?si=Ps6UwEXumkDe6vC9" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### Inverse Kinematics:

- In many third person and full-body FPS games, walking on stairs or uneven terrain often leads to floating or clipping feet. While often just a visual glitch, it can actually break locomotion if the offset is too high. Instead of asking animators for hundreds of edge-case animations, which limits level design I developed a procedural IK (Inverse Kinematics) system. Using ray-scanning, the system dynamically adjusts foot placement in real-time to keep movement grounded and fluid, regardless of the terrain.

Before & After Comparisons + result:

![BILD](/assets/pictures/IK2.png)
![BILD](/assets/pictures/IK.png)
![BILD](/assets/pictures/IK4.png)
![BILD](/assets/pictures/IK3.png)

<video width="640" height="360" controls>
  <source src="assets/videos/IK_Preview.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

<video width="640" height="360" controls>
  <source src="assets/videos/IK_AI.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/unity/inversekinematics)

- My approach to this system was significantly influenced by this specific demonstration, which guided my development of the ray-scanning logic:

<iframe width="560" height="315" src="https://www.youtube.com/embed/PryJ3CpHcXQ?si=KaBuUx3wL3ZQ3H1T" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<br/><br/>

- To further master the High Definition Render Pipeline (HDRP), I undertook a lighting and environment project by recreating a scene from the "Backrooms." This project allowed me to explore advanced features such as real-time ray tracing, volumetric lighting and performance optimization.
While the scene focused primarily on lighting and atmosphere rather than final set details (like decals or debris), it successfully captured the unsettling, sterile aesthetic of the original concept. You can see the progress of the study and the final atmosphere below:

![BILD](/assets/pictures/Project.png)
![BILD](/assets/pictures/Project2.png)
![BILD](/assets/pictures/Project3.png)

- In 2024, I expanded into streaming on Twitch and TikTok. Managing multiple platforms meant balancing content creation, video editing and community moderation all while staying hands on with my branding. I designed and rendered my own thumbnails in Blender, using custom props to ensure a unique visual style. You can see the full collection of my work over on my YouTube channel:

![BILD](/assets/pictures/Saga_Blend.png)
![BILD](/assets/pictures/Saga_Final.png)

[Link to the Video](https://youtu.be/xs0xGIgUxPI?si=4JPWe7Q1zgxhvWn-)

<br/><br/>
<br/><br/>

## 2025 – Present | Current Works: Systems & Immersion

#### Tech Stack: Unity Engine, Blender, Autodesk Maya & C#.

<br/><br/>

### Overview:

At the start of 2025, I began my career as a junior software developer in the healthcare area. While my work is under NDA and can’t be showcased here, I have stayed dedicated to my personal projects. The work below represents the milestones I have continued to reach in my own time, balancing professional growth with my passion for game development.

### Weapon System Development in Unity:

- I’m currently building a custom weapon system for a project I first started back in 2020. It’s a direct evolution of the mechanics I developed while modding GTA V, but now rebuilt from the ground up for a standalone game with much deeper combat and more polished handling.

![BILD](/assets/pictures/Project_Preview.png)

### VR Optimization & VRChat World Building:

- Alongside my other work, I’m also working on a custom environment for VRChat. The main goal here is the balancing act. Making the world look as good as possible without hurting the performance in VR. I’m using Udon (C#) to make the space interactive and feel alive. It’s still work in progress I’m currently smoothing out the lighting and a few rough edges but you are welcome to jump in and check it out here:

![BILD](/assets/pictures/VR_World.png)
![BILD](/assets/pictures/VR_World2.png)
![BILD](/assets/pictures/VR_World3.png)

### Note: 

- To visit, please host the world as a *private* instance through your VRChat account. If you run into any issues getting in, feel free to reach out! This world is currently optimized for PCVR and does not support Quest users yet. I hope you enjoy exploring it!

[Link to my World](https://vrchat.com/home/world/wrld_fe46f89a-220d-4ad7-ade2-da1bd19c02e5)

- I implemented several optimization techniques, including texture streaming, occlusion culling and baked lighting instead real-time lighting to ensure smooth performance even on lower-end hardware, so you should be fine. You can interact with the panel to toggle off objects to get more FPS boost. I also focused on localization to make the world accessible to a global audience and yes, even including full support for our Japanese folks! ♡

![BILD](/assets/pictures/VR_World_Localization.png)

##### [Source code](https://github.com/ArturHKBA/ArturHKBA.github.io/tree/main/assets/resources/unity/vrc)

- I recently released my latest VRChat avatar, which has already been used by over 250.000 players, making it one of the most popular models on the platform. Its success comes from its deep customization, with over 50+ toggles and an intuitive, symbol-based menu, users can easily tailor the avatar to their own identity. It features everything from dynamic PhysBones and custom expressions to interactive prefabs like a puppy bed, animated wings and a vast wardrobe. You can try out the public version and feel free to reach out if you have any questions or need help!

![BILD](/assets/pictures/VR_Avatar.png)
![BILD](/assets/pictures/VR_Avatar_Radial.png)

##### [Link to my VRChat Avatar](https://vrchat.com/home/avatar/avtr_33bf59e1-f041-46c4-8c4e-d6f59419e53d)

<br/><br/>
<br/><br/>

## MY PARTNERS:

- [Malbers Animations](https://www.artstation.com/malbersanimations)
- [Quang Phan](https://www.artstation.com/quangphan)
- [Quad Art](https://www.artstation.com/quadart_3d)

<br/><br/>

Thanks for stopping by! I’m always looking for new challenges and interesting people to collaborate with whether it's about game dev, software architecture or VR. If you have a project in mind or just want to talk, feel free to reach out!

Click [HERE](https://linktr.ee/arturhkba) for my Linktree
