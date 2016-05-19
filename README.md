davidt22-docker-lamp
=================

Out-of-the-box LAMP image (PHP+MySQL) for Docker


Usage
-----

First of all, you have to clone this repository in your local machine and go into the created folder.

To create the image `davidt22/lamp`, execute the following command on the davidt22-docker-lamp folder:

	docker build -t davidt22/lamp . 

You can now push your new image to the registry:

	docker push davidt22/lamp


Running your LAMP docker image
------------------------------

Start your image binding the external ports 80 and 3306 in all interfaces to your container:

	docker run -d -p 80:80 -p 3306:3306 davidt22/lamp

Test your deployment:

	curl http://localhost/

Hello world!


Loading your custom PHP application
-----------------------------------

In order to replace the "Hello World" application that comes bundled with this docker image,
create a new `Dockerfile` in an empty folder with the following contents:

	FROM davidt22/lamp:latest
	RUN rm -fr /app && git clone https://github.com/username/customapp.git /app
	EXPOSE 80 3306
	CMD ["/run.sh"]

replacing `https://github.com/username/customapp.git` with your application's GIT repository.
After that, build the new `Dockerfile`:

	docker build -t username/my-lamp-app .

And test it:

	docker run -d -p 80:80 -p 3306:3306 username/my-lamp-app

Test your deployment:

	curl http://localhost/

That's it!


Connecting to the bundled MySQL server from within the container
----------------------------------------------------------------

The bundled MySQL server has a `root` user with no password for local connections.
Simply connect from your PHP code with this user:

	<?php
	$mysql = new mysqli("localhost", "root");
	echo "MySQL Server info: ".$mysql->host_info;
	?>


Connecting to the bundled MySQL server from outside the container
-----------------------------------------------------------------

The first time that you run your container, a new user `admin` with all privileges
will be created in MySQL with a random password. To get the password, check the logs
of the container by running:

	docker logs $CONTAINER_ID

You will see an output like the following:

	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uadmin -padmin -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

In this case, `47nnf4FweaKu` is the password allocated to the `admin` user.

You can then connect to MySQL:

	 mysql -uadmin -padmin

Remember that the `root` user does not allow connections from outside the container -
you should use this `admin` user instead!


Setting a specific password for the MySQL server admin account
--------------------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `MYSQL_PASS` to your specific password when running the container:

	docker run -d -p 80:80 -p 3306:3306 -e MYSQL_PASS="mypass" davidt22/lamp

You can now test your new admin password:

	mysql -uadmin -p"mypass"


Disabling .htaccess
--------------------

`.htaccess` is enabled by default. To disable `.htaccess`, you can remove the following contents from `Dockerfile`

    # config to enable .htaccess
    ADD apache_default /etc/apache2/sites-available/000-default.conf
    RUN a2enmod rewrite


**by http://www.davidteruel.es**

First steps for a local project
-------------------------------
1- Clone this repository into your local machine

2- Run in console in same directory of Dockerfile:

    2.1- >> sudo docker build -t davidt22/lamp .   #This compiles the Dockerfile into a image with all instructions
    
    2.2- >> sudo docker run -tid -v /YOUR/LOCAL/ROUTE/PROJECT:/var/www --name davidt22_lamp davidt22/lamp #This executes a new instance(container) of your image
    
    2.3- >> sudo docker exec -ti davidt22_lamp bash #This access into the container via bash
    
    2.4- Modify the virtualhost by the name you choose using this
    
        2.4.1- >> nano /etc/apache2/sites-avaliable/000-default.conf
        
        2.4.2- Change the ServerName by yours 
        
        2.4.3- >>sudo apache2 restart/reload # restart apache
        
        2.4.4- Obtain the IP of the container with >> ifconfig
        
        2.4.5- In your local /etc/hosts file add map the IP with a name like: 172.17.0.9    www.myproject.local
        
   REMEMBER TO STOP YOUR APACHE2 AND MYSQL LOCAL IF YOU HAVE INSTALLED IT PREVIOUSLY ¡¡
        
