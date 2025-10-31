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




const Footer: React.FC = () => {

    const router = useRouter();



  return (
    <div className='flex h-full w-screen bg-black p-8'>
    <div className='w-full justify-around lg:ml-10 flex flex-col lg:flex-row'>
        <h1 className="ml-3 scroll-m-20 lg:text-3xl font-bold tracking-tight self-center text-white">
        ТОО АЛТЭК КАЗАХСТАН
        </h1>
        <h1 className="ml-3 scroll-m-20 lg:text-3xl font-bold tracking-tight self-center text-white">
        БИН 240640001701
        </h1>
        <h1 className="ml-3 scroll-m-20 lg:text-3xl font-bold tracking-tight self-center text-white">
        Астана, Сыганак 54А, офис 708/2
        </h1>
    </div>
    </div>
  );
};

export default Footer;
