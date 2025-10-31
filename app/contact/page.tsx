"use client"
import React, { useEffect, useState } from 'react';

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
import Image from "next/image";
import { Button } from '@/components/ui/button';
import Menu from '@/components/menu';
import Footer from '@/components/footer';


const Contact: React.FC = () => {


  return (
    <div className="flex w-screen h-full flex-col">
      <Menu/>
      <div className="flex flex-col align-middle justify-center h-screen">
        <h1 className="self-center scroll-m-20 text-2xl font-extrabold tracking-normal lg:text-4xl">Контакты для консультации</h1>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
            sales@td-altec.kz
          </h2>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
            +7 705 496 05 40
          </h2>
      </div>
      <Footer/>
    </div>
  );
};

export default Contact;
