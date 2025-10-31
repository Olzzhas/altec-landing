import React from 'react';
import Map, { Marker, Popup, NavigationControl } from 'react-map-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

// Типизация для проекта
interface Project {
  id: number;
  name: string;
  description: string;
  lat: number;
  lng: number;
}

// Пример данных проекта
const projects: Project[] = [
  { id: 1, name: 'Уличное освещение - светодиодные светильники', description: 'ООО ЭСТ', lat: 49.948325, lng: 82.627848 },
  { id: 2, name: 'Модульная котельная МКУ-В-12,5 в Карагандинской области', description: 'Группа ПКС', lat: 49.794608, lng: 73.083311 },
  { id: 3, name: 'Рудненская ТЭЦ', description: 'СибЭМ-БКЗ', lat: 52.973982, lng: 63.136194 },
  { id: 4, name: 'ТЭЦ-1, 2, 3 г. Астана', description: 'СибЭМ-БКЗ', lat: 51.143964, lng: 71.435819 },
  { id: 5, name: 'Павлодарская ТЭЦ-1, 2, 3', description: 'СибЭМ-БКЗ', lat: 52.285577, lng: 76.940722 },
  { id: 6, name: 'Семей ТЭЦ-1', description: 'СибЭМ-БКЗ', lat: 50.404976, lng: 80.249235  },
  { id: 7, name: 'Экибастузская ТЭЦ', description: 'СибЭМ-БКЗ', lat: 51.706765, lng: 75.334597 },
  // Добавьте больше проектов по необходимости
];

const MapComponent: React.FC = () => {
  const [selectedProject, setSelectedProject] = React.useState<Project | null>(null);

  const handleMarkerClick = (project: Project) => {
    console.log('Marker clicked:', project);
    setSelectedProject(project);
  };
  
  const handleMarkerLeave = (project: Project) => {
    console.log('Marker clicked:', project);
    setSelectedProject(null);
  };
  

  return (
    <Map
      initialViewState={{
        latitude: 48.0196,
        longitude: 66.9237,
        zoom: 3.5,
      }}
      style={{ width: '100%', height: '500px' }}
      mapStyle="mapbox://styles/solvasvas/clwiqnbtk00h501pc1munf571"
      mapboxAccessToken={process.env.NEXT_PUBLIC_MAPBOX_ACCESS_TOKEN}
      scrollZoom={false}
    >
      {projects.map((project) => (
        <Marker
          key={project.id}
          longitude={project.lng}
          latitude={project.lat}
          anchor="bottom"
        >
<div
  style={{ cursor: 'pointer', width: '50px', height:'50px'}}
  onMouseEnter={() => handleMarkerClick(project)}

>
            <img
              src="/placeholder.png"
              alt={project.name}
              style={{ width: '30px', height: '30px', borderRadius: 5, borderColor:'grey', borderWidth:1 }}
            />
          </div>

        </Marker>
      ))}

      {selectedProject && (
        <Popup
          longitude={selectedProject.lng}
          latitude={selectedProject.lat}
          onClose={() => setSelectedProject(null)}
          anchor='bottom'
        >
          <div>
            <strong>{selectedProject.name}</strong>
            <p>{selectedProject.description}</p>
          </div>
        </Popup>
      )}
                <NavigationControl position='bottom-right'/>
    </Map>
  );
};

export default MapComponent;
