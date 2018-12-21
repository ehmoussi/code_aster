! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine op9999(isave)
    use parameters_module, only : ST_OK
    implicit none
!     ------------------------------------------------------------------
! person_in_charge: j-pierre.lefebvre at edf.fr
!     OPERATEUR DE CLOTURE
!-----------------------------------------------------------------------
!     FIN OP9999
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/gettyp.h"
#include "asterc/jdcset.h"
#include "asterc/rmfile.h"
#include "asterfort/assert.h"
#include "asterfort/fin999.h"
#include "asterfort/get_jvbasename.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jefini.h"
#include "asterfort/jeimhd.h"
#include "asterfort/jeliad.h"
#include "asterfort/jelibf.h"
#include "asterfort/jemarq.h"
#include "asterfort/jetass.h"
#include "asterfort/jxcopy.h"
#include "asterfort/jxveri.h"
#include "asterfort/rsinfo.h"
#include "asterfort/ststat.h"
#include "asterfort/uimpba.h"
#include "asterfort/ulexis.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"

!   isave = 1 : The objects must be saved properly.
!   isave = 0 : The objects can be wiped out.
    integer, intent(in) :: isave

    mpi_int :: mrank, msize
    integer :: info, nbenre, nboct, iret, rank
    integer :: ifm, iunres, iunmes
    integer :: i, jco, nbco
    integer :: nbext, nfhdf
    aster_logical :: close_base
    character(len=8) :: k8b, ouinon, infr, proc
    character(len=16) :: fhdf, typres
    character(len=80) :: fich
    character(len=256) :: fbase
!-----------------------------------------------------------------------
!
    call jemarq()
    info = 1

    call asmpi_info(rank=mrank, size=msize)
    rank = to_aster_int(mrank)
!
!   --- PROC0 = 'OUI' pour effectuer les ecritures uniquement sur le processeur de rang 0 ---
!       si PROC0 = 'NON' on force rank=0
    proc = 'OUI'
    close_base = isave .eq. 1 .and. (proc.eq.'NON' .or. rank.eq.0)

    call ststat(ST_OK)

! --- MENAGE DANS LES BIBLIOTHEQUES, ALARMES, ERREURS, MPI
!
    call fin999()
!
! --- ecriture des informations sur le contenu de chaque sd_resultat :
!
    infr = 'NON'
    if (infr.eq.'OUI') then
        ifm = iunifi('MESSAGE')
!
        typres = 'RESULTAT_SDASTER'
        nbco = 0
        call gettyp(typres, nbco, k8b)
        if (nbco .gt. 0) then
            call wkvect('&&OP9999.NOM', 'V V K8', nbco, jco)
            call gettyp(typres, nbco, zk8(jco))
            do 10 i = 1, nbco
                write(ifm,100)
                call rsinfo(zk8(jco-1+i), ifm)
10          continue
        endif
    endif
!
    iunmes = iunifi('MESSAGE')
    iunres = iunifi('RESULTAT')
!
! --- SUPPRESSION DES CONCEPTS TEMPORAIRES DES MACRO
!
    if ( close_base ) then
      call jedetc('G', '.', 1)
!
! --- IMPRESSION DE LA TAILLE DES CONCEPTS DE LA BASE GLOBALE
!
      call uimpba('G', iunmes)
!
! --- RETASSAGE EVENTUEL DE LA GLOBALE
!
      ouinon = 'NON'
      if (ouinon .eq. 'OUI') call jetass('G')
!
! --- SAUVEGARDE DE LA GLOBALE AU FORMAT HDF
!
      fhdf = 'NON'
      fhdf = 'NON'
      nfhdf = 1
      if (nfhdf .gt. 0) then
        if (fhdf .eq. 'OUI') then
            if (ouinon .eq. 'OUI') then
                call utmess('A', 'SUPERVIS2_8')
            endif
            fich = 'bhdf.1'
            call jeimhd(fich, 'G')
        endif
     endif
   endif

!
! --- RECUPERE LA POSITION D'UN ENREGISTREMENT SYSTEME CARACTERISTIQUE
!
    call jeliad('G', nbenre, nboct)
    call jdcset('jeveux_sysaddr', nboct)
!
! --- APPEL JXVERI POUR VERIFIER LA BONNE FIN D'EXECUTION
!
    if ( close_base ) then
      call jxveri()
      !
      ! --- CLOTURE DES FICHIERS
      !
      call jelibf('SAUVE', 'G', info)
      !
      call jelibf('DETRUIT', 'V', info)
      !
      ! --- RETASSAGE EFFECTIF
      !
      if (ouinon .eq. 'OUI') then
        call jxcopy('G', 'GLOBALE', 'V', 'VOLATILE', nbext)
        if (iunres .gt. 0) write(iunres, '(A,I2,A)'&
        ) ' <I> <FIN> RETASSAGE DE LA BASE "GLOBALE" EFFECTUEE, ',&
        nbext, ' FICHIER(S) UTILISE(S).'
      endif

      ! the diagnosis of the execution is OK thanks to the message
      call utmess('I', 'SUPERVIS2_99')
    endif

    call jedema()
!
! --- CLOTURE DE JEVEUX
!
    call jefini('NORMAL', close_base)

    if ( isave .eq. 0 ) then
        do i=1,99
            call get_jvbasename('glob', i, fbase)
            call rmfile(fbase, 0, iret)
            if (iret .ne. 0) then
                exit
            endif
            call get_jvbasename('vola', i, fbase)
            call rmfile(fbase, 0, iret)
        end do
    endif

100 format(/,1x,'======>')
!
end subroutine
