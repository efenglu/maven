package com.efenglu.javaSample

import spock.lang.Specification


class TestPojoSpec extends Specification {

    def "test pojo"() {
        given:
        TestPojo testPojo = TestPojo.builder().s1("hello").build()

        when:
        testPojo.s1 = "hello2"

        then:
        thrown(ReadOnlyPropertyException)
    }

}