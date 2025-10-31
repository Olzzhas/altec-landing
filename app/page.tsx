"use client"
import Footer from "@/components/footer";
import Menu from "@/components/menu";
import { Button } from "@/components/ui/button";
import Image from "next/image";
import dynamic from 'next/dynamic';
import { useState } from "react";



export default function Home() {
  const DynamicMap = dynamic(() => import('@/components/map'), { ssr: false });

  const participants = [
    {
      name: "ООО «Барнаульский Завод Винтовых Свай»",
      link: "https://bzvs.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/bzvs.png" 
    },
    {
      name: "ООО «АЗИС №1»",
      link: "https://azis.pro/",
      image: "https://altayenergoklaster.ru/images/uchastniki/azis.png" 
    },
    {
      name: "ООО «СибАрмаГаз»",
      link: "https://sib-ag.ru/",
      image: "https://www.sib-ag.ru/img/logo.svg" 
    },
    {
      name: "ООО «АРГУМ»",
      link: "https://argum.pro/",
      image: "https://altayenergoklaster.ru/images/uchastniki/argum.png"
    },
    {
      name: "ООО «Котельный завод ПРОМКОТЛОСНАБ»",
      link: "https://kotlosnab.ru/",
      image: "https://static.tildacdn.com/tild6535-3462-4831-b165-323739326431/logo_pks.svg" 
    },
    {
      name: "АО «Редукционно-охладительные установки»",
      link: "http://rou.ru",
      image: "https://altayenergoklaster.ru/images/uchastniki/redukc-ohlad-ust.png"
    },
    {
      name: "ООО «Барнаульский завод энергетического оборудования им. Воеводина Д.В.»",
      link: "https://bzeo.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/bzeo.png"
    },
    {
      name: "ООО «Топ Смарт»",
      link: "https://electroshkaf.su/",
      image: "https://altayenergoklaster.ru/images/uchastniki/top-smart.png"
    },
    {
      name: "АО «АЛТТРАНС»",
      link: "https://alttrans.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/alttrans.png"
    },
    {
      name: "ООО «Барнаульский котельный завод»",
      link: "https://bkzn.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/bkz.png"
    },
    {
      name: "ООО «БАРНАУЛЭНЕРГОМАШ»",
      link: "https://bemz.pro/",
      image: "https://bemz.pro/images/dist/logo.svg"
    },
    {
      name: "ООО «Сибэнергомаш - БКЗ»",
      link: "https://sibem-bkz.com/",
      image: "https://altayenergoklaster.ru/images/uchastniki/sibem-bkz.png"
    },
    {
      name: "ООО «ПРОТЭКТ»",
      link: "https://protekt22.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/protekt.png"
    },
    {
      name: "ООО «Энергосберегающие технологии»",
      link: "https://est22.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/est2.png"
    },
    {
      name: "ООО «Алтайский Завод Дизельных Агрегатов»",
      link: "http://altzda.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/azda.png"
    },
    {
      name: "ООО «Инженерный центр «ВИТОТЕХ»",
      link: "http://vitotec.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/vitoteh.png"
    },
    {
      name: "ООО «ПромСтройМеталлоКонструкция»",
      link: "http://psmk-org.1gb.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/psmk.png"
    },
    {
      name: "ООО «ТеплоГенерация»",
      link: "http://rosnaladka.ru/",
      image: "/youn.png"
    },
    {
      name: "АО «Алтайский Машиностроительный Завод Газэнергомаш»",
      link: "https://gazenergomash.su/",
      image: "https://altayenergoklaster.ru/images/uchastniki/gazenergomash.png"
    },
    {
      name: "ООО «ПО «Межрегионэнергосервис»",
      link: "https://zaomes.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/mes.png"
    },
    {
      name: "ООО «Инжиниринг Энергетических Систем»",
      link: "https://reengineer.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/inzh-energo-sistem.png"
    },
    {
      name: "ООО «Сибэнергомонтаж»",
      link: "http://sibenergomontag.ru/",
      image: "https://altayenergoklaster.ru/images/uchastniki/snek.png"
    },
  ];

  const [phoneNumber, setPhoneNumber] = useState('+7 (777) 522-91-80'); // Replace with actual phone number

  const handleDial = () => {
    window.location.href = `tel:${phoneNumber}`;
  };
  

  return (
    <main className="flex w-screen flex-col">
      <Menu/>
      <div className="flex lg:h-screen w-full bg-slate-50 relative justify-center">
      <Image
        src="/7.jpg"
        alt=''
        width={200}
        height={200}
        className='rounded-lg'
        style={{
          width: "100%",
          height: "100%"
        }} />
        <div className="absolute inset-0 bg-black opacity-60"></div>
        <div className="absolute self-center align-middle">
          <div className="justify-center flex w-full">
          <h1 className="scroll-m-20 text-lg lg:text-5xl font-extrabold tracking-normal text-white">
            Торговый дом АЛТЭК Казахстан
          </h1>
          </div>
          <div className="justify-center flex w-full">
          <h2 className="scroll-m-20 pb-2 lg:text-3xl font-semibold tracking-tight first:mt-2 text-white text-center">
            Единое окно взаимодействия с более 30 заводами производителями оборудования и комплектующих в сфере энергетики
          </h2>
          </div>
          <div className="justify-center flex w-full mt-7">
            <Button variant={'secondary'} onClick={handleDial}>
              Связаться с отделом продаж
            </Button>
          </div>
        </div>
      </div>
      <div className="flex w-full justify-center flex-col mt-8">
        <div className="justify-center flex w-full">
          <h3 className="scroll-m-20 lg:text-2xl font-semibold tracking-tight">Что производят заводы АЛТЭК?</h3>
        </div>
        <div className="justify-center flex w-full">
          <h4 className="scroll-m-20 lg:text-xl font-semibold tracking-tight"></h4>
        </div>


        <div className="flex flex-wrap p-8 align-middle justify-around w-screen gap-2">
          <div className="flex w-1/3 lg:w-1/4 bg-slate-50 relative justify-center">
            <Image
              src="/1.jpg"
              alt=''
              width={200}
              height={200}
              className='rounded-lg'
              style={{
                width: "100%",
                height: "100%"
              }} />

              <div className="absolute inset-0 bg-black opacity-60 rounded-lg"></div>
              
              <div className="absolute self-center align-middle contain-content">
                <h2 className="scroll-m-20 pb-2 text-xs text-center lg:text-2xl font-semibold tracking-tight first:mt-2 text-white">
                    Котельное оборудование и комплектующие
                </h2>
              </div>
          </div>
          <div className="flex w-1/3 lg:w-1/4 bg-slate-50 relative justify-center">
            <Image
              src="/5.webp"
              alt=''
              width={200}
              height={200}
              className='rounded-lg'
              style={{
                width: "100%",
                height: "100%"
              }} />

            <div className="absolute inset-0 bg-black opacity-60 rounded-lg"></div>
            
            <div className="absolute self-center align-middle justify-center">
              <h2 className="scroll-m-20 pb-2 text-xs text-center  lg:text-2xl font-semibold tracking-tight first:mt-2 text-white">
                  Электротехническое оборудование и конструкции
              </h2>
            </div>
          </div>
          <div className="flex w-1/3 lg:w-1/4 bg-slate-50 relative justify-center">
            <Image
              src="/3.png"
              alt=''
              width={200}
              height={200}
              className='rounded-lg'
              style={{
                width: "100%",
                height: "100%"
              }} />

              <div className="absolute inset-0 bg-black opacity-60 rounded-lg"></div>
              
              <div className="absolute self-center align-middle">
              <h2 className="scroll-m-20 pb-2 text-xs text-center  lg:text-2xl font-semibold tracking-tight first:mt-2 text-white">
                  Автоматика
              </h2>
              </div>
          </div>
          <div className="flex w-1/3 lg:w-1/4 bg-slate-50 relative justify-center">
            <Image
              src="/6.jpg"
              alt=''
              width={200}
              height={200}
              className='rounded-lg'
              style={{
                width: "100%",
                height: "100%"
              }} />

              <div className="absolute inset-0 bg-black opacity-60 rounded-lg"></div>
              
              <div className="absolute self-center align-middle contain-content">
                <h2 className="scroll-m-20 pb-2 text-xs text-center  lg:text-2xl font-semibold tracking-tight first:mt-2 text-white">
                    Задвижки, клапаны, изолирующие соединения
                </h2>
              </div>
          </div>
          <div className="flex w-1/3 lg:w-1/4 bg-slate-50 relative justify-center">
            <Image
              src="/4.jpg"
              alt=''
              width={200}
              height={200}
              className='rounded-lg'
              style={{
                width: "100%",
                height: "100%"
              }} />
                     
            <div className="absolute inset-0 bg-black opacity-60 rounded-lg"></div>
            
            <div className="absolute self-center align-middle justify-center">
              <h2 className="scroll-m-20 pb-2 text-xs text-center  lg:text-2xl font-semibold tracking-tight first:mt-2 text-white">
                  Уличное и внутреннее освещение
              </h2>
            </div>
          </div>
          <div className="flex w-1/3 lg:w-1/4 bg-slate-50 relative justify-center">
            <Image
              src="/2.jpg"
              alt=''
              width={200}
              height={200}
              className='rounded-lg'
              style={{
                width: "100%",
                height: "100%"
              }} />
                    
              <div className="absolute inset-0 bg-black opacity-60 rounded-lg"></div>
         
              <div className="absolute self-center align-middle">
              <h2 className="scroll-m-20 pb-2 text-xs text-center lg:text-2xl font-semibold tracking-tight first:mt-2 text-white">
                  Дизельные электростанции
              </h2>
              </div>
          </div>
        </div>

      </div>
      <div className="flex w-full flex-col lg:flex-row mt-2">
        <div className="flex p-16 lg:w-1/2 justify-center align-middle flex-col">
          <h1 className="scroll-m-20 text-2xl font-extrabold tracking-normal lg:text-4xl">О нас</h1>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
            ТОО АЛТЭК Казахстан является официальным дистрибьютером более 30 производителей кластера АЛТЭК на территории Республики Казахстан
          </h2>
        </div>
        <div className="lg:w-1/2 p-8">
          <Image
            src="/start.png"
            alt=''
            width={500}
            height={500}
            className='rounded-lg'
            style={{
              width: "100%",
              height: "100%"
          }} />
        </div>
      </div>
      <div className="flex w-full flex-col lg:flex-row mt-8">
      <div className="lg:w-1/2 p-8">
      <DynamicMap />
      </div>
      <div className="flex p-16 lg:w-1/2 justify-center align-middle flex-col">
          <h1 className="scroll-m-20 text-2xl font-extrabold tracking-normal lg:text-3xl">На рынке Казахстана с 2011 года</h1>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
          - проектирование оборудования, объектов энергетики, а также экспертная поддержка проектных организаций
          </h2>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
          - производство оборудования и комплектующих любой сложности под ваши требования
          </h2>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
          - доставка до места назначения, монтаж оборудования и гарантийное обслуживание от производителя
          </h2>
        </div>

    </div>
    <h1 className="scroll-m-20 text-2xl font-extrabold tracking-normal lg:text-3xl self-center mt-6">Производители кластера:</h1>
    <div className="flex flex-wrap w-full p-6 space-y-2 space-x-2 justify-around">

          {participants.map((participant, index) => (
            <div key={index} className="sm:w-1/3 lg:w-1/12 flex" onClick={() => window.open(participant.link, "_blank")}>
              <Image
                          src={participant.image}
                          alt=''
                          width={120}
                          height={120}
                          className='rounded-lg self-center'
              />
            </div>
          ))}
        </div>
      <div className="flex flex-col align-middle justify-center h-96">
        <h1 className="self-center scroll-m-20 text-2xl font-extrabold tracking-normal lg:text-4xl text-center">Контакты для консультации и подбора оборудования</h1>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
            sales@td-altec.kz
          </h2>
          <h2 className="self-center scroll-m-20 text-xl font-light tracking-tight mt-6">
            +7 705 496 05 40
          </h2>
      </div>
      <Footer/>
    </main>
  );
}
