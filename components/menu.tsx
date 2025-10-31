"use client"
import React from 'react';

import { useRouter } from 'next/navigation';
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuIndicator,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
  NavigationMenuViewport,
} from "@/components/ui/navigation-menu"
import { navigationMenuTriggerStyle } from "@/components/ui/navigation-menu"
import Link from 'next/link';
import { Button } from './ui/button';
import Image from "next/image";




const Menu: React.FC = () => {

    const router = useRouter();
    const scrollToContacts = () => {
      router.push('/Home');
  };


  return (
    <div className='flex flex-col h-full w-screen lg:flex-row'>
    <div className='w-full justify-center lg:justify-start lg:ml-10 flex flex-row lg:w-1/3'>
      <Image
        src="/placeholder.png"
        alt=''
        width={90}
        height={90}
        className='rounded-lg p-1'
        style={{
          maxWidth: "100%",
          height: "auto"
        }} />
        <h1 className="scroll-m-20 text-3xl font-bold tracking-tight lg:text-3xl self-center">
        АЛТЭК Казахстан
        </h1>
    </div>
    <div className='flex lg:w-2/3 lg:justify-end w-full justify-center'>
    <NavigationMenu className='lg:mr-10'>
      <NavigationMenuList>
        <NavigationMenuItem>
          <Link href="/" legacyBehavior passHref>
            <NavigationMenuLink className={navigationMenuTriggerStyle()}>
              Главная
            </NavigationMenuLink>
          </Link>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <Link href="/contact" legacyBehavior passHref>
            <NavigationMenuLink className={navigationMenuTriggerStyle()}>
              Контакты
            </NavigationMenuLink>
          </Link>
        </NavigationMenuItem>
      </NavigationMenuList>
    </NavigationMenu>
    </div>
    </div>
  );
};

export default Menu;
