import { ref } from 'vue'

const monthObtained = ref(false)

const setMonthObtained = (value) => {
  monthObtained.value = value
}

const getMonthObtained = () => {
  return monthObtained.value
}

export default function useMonthObtained() {
  return {
    monthObtained,
    setMonthObtained,
    getMonthObtained
  }
}
