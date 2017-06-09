! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine cgveli(typfis, typdis, cas, lnoff, liss,&
                  ndeg)
    implicit none
!
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
    integer :: lnoff, ndeg
    character(len=8) :: typfis
    character(len=16) :: cas, typdis
    character(len=24) :: liss
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : VERIFICATION DES DONNEES RELATIVES AU LISSAGE
!
!  IN :
!     TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
!             ('FONDIFSS' OU 'FISSURE')
!     CAS    : '2D', '3D LOCAL' OU '3D GLOBAL'
!     LNOFF  : NOMBRE DE NOEUDS (OU POINTS) DU FOND DE FISSURE
!     TYPDIS : TYPE DE DISCONTINUITE SI FISSURE XFEM 
!              'FISSURE' OU 'COHESIF'
!  OUT :
!     LISS   : TYPE DE LISSAGE (NOM CONTRACTE)
!     NDEG   : DEBRE DES POLYNOMES DE LEGENDRE
!              (-1 DANS LES CAS OU DEGRE N'A PAS DE SENS)
! ======================================================================
!
    integer :: ier, iarg
    character(len=24) :: lissg, lissth
!
!     ----------------------------------------------------------
!     LISSAGE_G         LISSAGE_THETA         NOUVEAU NOM
!     ----------------------------------------------------------
!     LEGENDRE        +  LEGENDRE         ->   LEGENDRE
!     LEGENDRE        +  LAGRANGE         ->   MIXTE
!     LAGRANGE        +  LAGRANGE         ->   LAGRANGE
!     LAGRANGE_NO_NO  +  LAGRANGE         ->   LAGRANGE_NO_NO
!     ----------------------------------------------------------
!     TOUTES LES AUTRES COMBINAISONS SONT INTERDITES
!     ----------------------------------------------------------
!
!     INITIALISATIONS
    liss=' '
    ndeg=-1
!
    if (cas .ne. '3D_LOCAL') then
!
!       L'UTILISATEUR NE DOIT PAS AVOIR RENSEIGNE LISSAGE_G
        call getvtx('LISSAGE', 'LISSAGE_G', iocc=1, scal=lissg, nbret=ier,&
                    isdefault=iarg)
        if (iarg .eq. 0) then
            call utmess('A', 'RUPTURE0_67')
        endif
!
!       L'UTILISATEUR NE DOIT PAS AVOIR RENSEIGNE LISSAGE_THETA
        call getvtx('LISSAGE', 'LISSAGE_THETA', iocc=1, scal=lissth, nbret=ier,&
                    isdefault=iarg)
        if (iarg .eq. 0) then
            call utmess('A', 'RUPTURE0_67')
        endif
!
    else if (cas.eq.'3D_LOCAL') then
!
        call getvtx('LISSAGE', 'LISSAGE_G', iocc=1, scal=lissg, nbret=ier,&
                    isdefault=iarg)
        call getvtx('LISSAGE', 'LISSAGE_THETA', iocc=1, scal=lissth, nbret=ier,&
                    isdefault=iarg)
!
        if (lissg .eq. 'LEGENDRE' .and. lissth .eq. 'LEGENDRE') then
            liss='LEGENDRE'
        else if (lissg.eq.'LEGENDRE'.and.lissth.eq.'LAGRANGE') then
            liss='MIXTE'
        else if (lissg.eq.'LAGRANGE'.and.lissth.eq.'LAGRANGE') then
            liss='LAGRANGE'
            elseif (lissg.eq.'LAGRANGE_NO_NO'.and.lissth.eq.'LAGRANGE')&
        then
            liss='LAGRANGE_NO_NO'
        else
            call utmess('F', 'RUPTURE0_86')
        endif
!
!       COMPATIBILITE ENTRE LISSAGE ET TYPFIS
        if (typfis .eq. 'FISSURE' .and. liss .eq. 'MIXTE') then
            call utmess('F', 'RUPTURE0_76')
        endif
!
!       COMPATIBILITE ENTRE LISSAGE ET OPTION
        if(liss.eq.'MIXTE'.or.liss.eq.'LEGENDRE') then
            if(typdis.eq.'COHESIF') then
                call utmess('F', 'RUPTURE2_5')
            endif
        endif
!
!       RECUPERATION DU DEGRE DES POLYNOMES DE LEGENDRE
        call getvis('LISSAGE', 'DEGRE', iocc=1, scal=ndeg, nbret=ier,&
                    isdefault=iarg)
!
!       COMPATIBILITE DES DIMENSIONS DES ESPACES EN LISSAGE MIXTE
        if (liss .eq. 'MIXTE') then
            if (ndeg .ge. lnoff) then
                call utmess('F', 'RUPTURE0_84', si=lnoff)
            endif
        endif
!
    endif
!
!
end subroutine
